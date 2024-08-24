ridgepole:
	bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile
ridgepole -t:
	bundle exec ridgepole -c config/database.yml -E test --apply -f db/Schemafile
