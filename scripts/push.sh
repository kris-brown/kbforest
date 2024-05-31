/nix/store/3ylkpp629vaf40rh1if5646bv04kb405-forester-4.0.1/bin/forester build || exit 1
julia scripts/check_filenames.jl || exit 1
rm -r ../netlify/forest
cp -r output ../netlify/forest
cd ../netlify/forest 
git add .
git commit -m "forest"
git push
cd -