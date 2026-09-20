FROM nginx:alpine

# Cache bust: 20260920235354
# Download icon fonts from jsDelivr CDN v14 (matches bundle)
RUN apk add --no-cache wget curl && \
    mkdir -p /usr/share/nginx/html/fonts && \
    cd /usr/share/nginx/html/fonts && \
    BASE="https://cdn.jsdelivr.net/npm/@expo/vector-icons@14/build/vendor/react-native-vector-icons/Fonts" && \
    for font in AntDesign Entypo EvilIcons Feather Fontisto FontAwesome \
                FontAwesome5_Brands FontAwesome5_Regular FontAwesome5_Solid \
                FontAwesome6_Brands FontAwesome6_Regular FontAwesome6_Solid \
                Foundation Ionicons MaterialCommunityIcons MaterialIcons \
                Octicons SimpleLineIcons Zocial; do \
        wget -q "${BASE}/${font}.ttf" -O "${font}.ttf"; \
    done

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Always download the latest index.html from GitHub (never use Docker cache for this)
RUN curl -fsSL "https://raw.githubusercontent.com/osquelcruz67-create/citasya-frontend/main/index.html?bust=20260920235354" \
    -o /usr/share/nginx/html/index.html

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
