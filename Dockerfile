FROM nginx:alpine

# Cache bust: 2026-09-20-v3
# Download icon fonts from jsDelivr CDN v14 (matches bundle)
RUN mkdir -p /usr/share/nginx/html/fonts && \
    cd /usr/share/nginx/html/fonts && \
    BASE="https://cdn.jsdelivr.net/npm/@expo/vector-icons@14/build/vendor/react-native-vector-icons/Fonts" && \
    for font in AntDesign Entypo EvilIcons Feather Fontisto FontAwesome \
                FontAwesome5_Brands FontAwesome5_Regular FontAwesome5_Solid \
                FontAwesome6_Brands FontAwesome6_Regular FontAwesome6_Solid \
                Foundation Ionicons MaterialCommunityIcons MaterialIcons \
                Octicons SimpleLineIcons Zocial; do \
        wget -q "${BASE}/${font}.ttf" -O "${font}.ttf" || \
        curl -fsSL "${BASE}/${font}.ttf" -o "${font}.ttf"; \
    done && \
    echo "=== Fonts downloaded ===" && \
    ls -la /usr/share/nginx/html/fonts/

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
