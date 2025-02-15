while sleep 8; do (forester build --dev role.toml &); done

# watch -n 10 $@ -- "forester build --dev role.toml"
