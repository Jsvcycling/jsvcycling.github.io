bundle exec jekyll serve -H $(ip route get 1 | awk '{print $NF;exit}')
