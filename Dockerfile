FROM nginx:alpine
RUN echo "<h1>(PRT – CI/CD Completed Successfully)</h1>" > /usr/share/nginx/html/index.html
EXPOSE 80
