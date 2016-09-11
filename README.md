# Apache PHP7 MySQL Redis
<p>Base Docker image for development environments using Apache, PHP7, MySQL and Redis.</p>
<p>Registered on Docker as <strong>cvsouth/apache-php7-mysql-redis</strong>.</p>
<p>For an environment template which uses this as it's base image see <a href="https://github.com/cvsouth/template-environment">cvsouth/template-environment</a>.</p>
## Known limitations
### Database persistence
<ul>
  <li>Database will be wiped every time the image is started. Will revisit soon.</li>
  <li>You have to run composer manually from the project folder.</li>
</ul>
