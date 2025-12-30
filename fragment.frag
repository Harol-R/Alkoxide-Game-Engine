#version 330 core
in vec2 uv;
out vec4 FragColor;

uniform sampler2D texture1;
uniform vec2 uvScale;
uniform vec2 uvOffset;

void main() {
    // Color rosa fuerte
    //FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    vec2 finalUv = uvOffset + (uv * uvScale);
    FragColor = texture(texture1, finalUv);
    
}