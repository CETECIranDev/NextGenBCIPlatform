#version 440

in vec2 qt_TexCoord0;
out vec4 fragColor;

uniform highp float qt_Opacity;
uniform sampler2D source;
uniform lowp vec4 shadowColor; // تغییر به vec4 برای سازگاری بهتر
uniform lowp float blurRadius;
uniform lowp vec2 offset;
uniform highp vec2 sourceSize; // اندازه آیتم منبع

void main() {
    float alpha = 0.0;
    // محاسبه گام بر اساس اندازه واقعی آیتم برای دقت بیشتر
    float stepX = 1.0 / sourceSize.x;
    float stepY = 1.0 / sourceSize.y;

    // کاهش تعداد نمونه‌ها برای عملکرد بهتر (می‌توانید این را تنظیم کنید)
    float samples = min(blurRadius, 8.0);

    for (float y = -samples; y <= samples; ++y) {
        for (float x = -samples; x <= samples; ++x) {
            vec2 samplePos = qt_TexCoord0 + vec2(x * stepX, y * stepY) - (offset / sourceSize);
            // اطمینان از اینکه خارج از بافت نمونه‌برداری نمی‌کنیم
            if (samplePos.x > 0.0 && samplePos.x < 1.0 && samplePos.y > 0.0 && samplePos.y < 1.0) {
                alpha = max(alpha, texture(source, samplePos).a);
            }
        }
    }

    fragColor = vec4(shadowColor.rgb, alpha * shadowColor.a) * qt_Opacity;
}