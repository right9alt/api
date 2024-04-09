module Queries
  module PostsQuery

    module_function

    module PostsDecorator

      def comments
        Comment.where(id:)
      end

    end

    def lenta(current_user_id)
      MINI_SQL.query_decorator(PostsDecorator, <<~SQL, current_user_id:)
        WITH subscriptions_posts AS ( -- Выбираем все посты таких пользователей на кого кто-то подписан и тот кто подписан на них это текущий пользователь
          SELECT posts.*
          FROM posts
          INNER JOIN relationships
            ON posts.user_id = relationships.followee_id 
            AND relationships.follower_id = :current_user_id
        ),
        liked_posts AS ( -- Выбираем все посты и пересекаем их с лайками у которых тип Пост и лайкнувший - текущий пользователь
          SELECT posts.*
          FROM posts
          INNER JOIN likeables
            ON posts.id = likeables.likeable_id
            AND likeables.likeable_type = 'Post'
            AND likeables.user_id = :current_user_id
        ),
        user_posts_whos_posts_was_liked AS ( -- Выбираем все посты пользователей чьи посты мы лайкнули за последние 5 дней
          SELECT posts.*
          FROM posts
          WHERE posts.user_id = ANY(
            SELECT DISTINCT liked_posts.user_id
            FROM liked_posts
            INNER JOIN likeables
              ON liked_posts.id = likeables.likeable_id
              AND likeables.likeable_type = 'Post'
              AND likeables.created_at >= CURRENT_DATE - INTERVAL '5 days'
          )
        )
        SELECT * FROM (
            SELECT * FROM posts WHERE user_id = :current_user_id
            UNION
            SELECT * FROM subscriptions_posts
            UNION
            SELECT * FROM liked_posts
            UNION
            SELECT * FROM user_posts_whos_posts_was_liked
        ) AS all_posts
        ORDER BY created_at DESC;
      SQL
    end
  end
end