# Reddit Clone

Reddit On Rails - An App Academy project to create a Rails clone of Reddit.

## Features

- User authentication (not using secure_password and devise as part of assignment)
- Moderated sub(reddit)s (AKA Sub creator and Post can edit/delete Posts)
- Cross-sub posts
- Nested comments
- Upvote/downvote per post and per comment
- Pagination for Subs and Posts
- User-friendly URLS
- No N+1 queries thanks to Bullet gem

## Learning Goals (pasted from the [assignment](https://open.appacademy.io/learn/full-stack-online/rails/redditclone))
- Be able to write auth from scratch without looking at previous solutions
- Know how to use a before_action to manage user access to resources
- Be able to write Rails models, controllers, and views quickly
- Know when to use regular associations and when to use join tables
- Know how to avoid N+1 queries

Warning - Forms are not re-rendered but redirect to actions - ergo forms get cleared on errors.
This is due to flash.now not showing/updating the error/notification bar on rendering.
It is on purpose, but not ideal.
Sorry for the inconvenience.
