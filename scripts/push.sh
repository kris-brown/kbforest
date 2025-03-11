./forester build || exit 1
julia scripts/check_filenames.jl || exit 1
rm -r ../netlify/forest
cp -r output ../netlify/forest
cd ../netlify/forest 
git add .
git commit -m "forest"
git push
cd -