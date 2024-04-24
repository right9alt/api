preinstall: ; docker-compose run --rm runner
install:    ; bundle install; rails db:create db:migrate
start:      ; docker-compose up
clean:      ; docker-compose down --volumes --rmi all -v --remove-orphans