git clone https://github.com/fronoske/bitclust.git
cd bitclust
git clone https://github.com/rurema/doctree.git rubydoc
bundle install --path=vendor/bundle
echo finish bundle install
bundle exec bitclust -d ./db init encoding=utf-8 version=2.7.0
echo finish bundle exec bitclust init
bundle exec bitclust -d ./db update --stdlibtree=./rubydoc/refm/api/src
echo finish bundle exec bitclust update
if exist chm ( rmdir /S /Q chm )
bundle exec bitclust -d ./db chm -o ./chm
echo finish bundle exec bitclust chm
