JEKYLL_ENV=production bundle exec jekyll b

git add .
git commit -m "new post"
git push

#ansible-playbook deploy.yml --user pugtech --ask-become-pass -i ../ansible/inventory/hosts
