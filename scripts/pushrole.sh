forester build role.toml || exit 1
julia scripts/check_filenames.jl || exit 1
rm -r ../netlify/role
cp -r output ../netlify/role
cd ../netlify/role 
git add .
git commit -m "role"
git push
cd -