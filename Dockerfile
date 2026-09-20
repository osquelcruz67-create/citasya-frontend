# Stage 1: download icon fonts from npm
FROM node:20-alpine AS fonts
WORKDIR /fonts
RUN npm install --no-save @expo/vector-icons@latest 2>/dev/null; \
    cp node_modules/@expo/vector-icons/build/vendor/react-native-vector-icons/Fonts/*.ttf . 2>/dev/null; \
    ls *.ttf

# Stage 2: nginx server
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY --from=fonts /fonts/*.ttf /usr/share/nginx/html/fonts/
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
