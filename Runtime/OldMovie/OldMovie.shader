Shader "Hidden/VolFx/OldMovie"
{
    Properties
    {
        _Vignette("Vignette", Vector) = (0, 0, 0, 0)
        _Grain("Grain", Vector) = (0, 0, 0, 0)
        _Tint("Grain", Color) = (0, 0, 0, 0)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }
        LOD 0

        ZTest Always
        ZWrite Off
        ZClip false
        Cull Off

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl" 
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            float4 _Vignette;   // x - intensity, y - power, z - grain, w - noise alpha
            float4 _Grain;
            float4 _Tint;
            float4 _Jolt;

            sampler2D    _MainTex;
            sampler2D    _GrainTex;
            sampler2D    _NoiseTex;

            struct vert_in
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct frag_in
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            frag_in vert (vert_in v)
            {
                frag_in o;
                o.vertex = v.vertex;
                o.uv = v.uv;
                return o;
            }

            half4 frag (frag_in i) : SV_Target
            {
	            float2 uv = i.uv;
               
                uv *= 1.0 - uv.yx;                      // vec2(1.0)- uv.yx; -> 1.-u.yx
                float vig = uv.x * uv.y * _Vignette.x;  // multiply with sth for intensity
                vig = pow(vig, _Vignette.y);            // change pow for modifying the extend of the vignette
                
                half4 main = tex2D(_MainTex, i.uv + _Jolt.xy);

                half grain = tex2D(_GrainTex, i.uv * _Grain.xy + _Grain.zw).w;
                grain = abs((grain - 0.5) * _Vignette.z);
                
                half3 noise = tex2D(_NoiseTex, i.uv + _Jolt.xy).rgb;
                main.rgb += noise * _Vignette.w;

                main.rgb += grain.rrr;
                main.rgb  = lerp(main.rgb, _Tint.rgb, (1 - vig) * _Tint.a);
                return main;
            }
            ENDHLSL
        }
    }
}