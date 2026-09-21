FROM nginx:alpine

# Cache bust: 20260921184500
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

# Download latest index.html from GitHub
RUN curl -fsSL "https://raw.githubusercontent.com/osquelcruz67-create/citasya-frontend/main/index.html?bust=20260921184500" \
    -o /usr/share/nginx/html/index.html

# Download JS bundle from Emergent preview (retry until server is awake)
RUN for i in $(seq 1 12); do \
      curl -fsSL --max-time 60 \
        "https://viralmen-hub.preview.emergentagent.com/node_modules/expo-router/entry.bundle?platform=web&dev=true&hot=false&lazy=true&transform.engine=hermes&transform.routerRoot=app&unstable_transformProfile=hermes-stable" \
        -o /usr/share/nginx/html/bundle.js && \
      head -c 30 /usr/share/nginx/html/bundle.js | grep -q "BUNDLE_START_TIME" && break; \
      echo "Retry $i - server waking up..."; sleep 15; \
    done && \
    ls -lh /usr/share/nginx/html/bundle.js

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
