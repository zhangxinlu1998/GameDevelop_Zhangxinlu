// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Sketch"
{
    Properties
    {
        _Color("MainColor",Color)=(1,1,1,1)
        [NoScaleOffset]_MainTex("MainTex",2D) = "White"{}
        [NoScaleOffset]_EmissionTex("Emission Tex",2D) = "White"{}
        [HDR]_EmissionCol("Emission Color",color) = (1,1,1,1)
        [MaterialToggle] _Outline( "Outline", int ) = 1
        _OutlineStrength("Outline Strength",Range(0,1)) = 0.1
        _OutlineColor("OutlineColor",Color) = (1,1,1,1)
        _TileFactor("Tile Factor",Float) = 1
        [NoScaleOffset]_Hatch0("Hatch 0",2D) = "white" {}
        [NoScaleOffset]_Hatch1("Hatch 1",2D) = "white" {}
        [NoScaleOffset]_Hatch2("Hatch 2",2D) = "white" {}
        [NoScaleOffset]_Hatch3("Hatch 3",2D) = "white" {}
        [NoScaleOffset]_Hatch4("Hatch 4",2D) = "white" {}
        [NoScaleOffset]_Hatch5("Hatch 5",2D) = "white" {}
        _lightRange("lightRange",float) = 0
        _Shadowcol("Shadowcol",Color) = (0,0,0,0)
        _ShadowSmooth("ShadowSmooth",Range(0,1)) = 0.1
        _ShadowAlpha("ShadowAlpha",Range(0,1)) = 0.5
        _ShadowOffset("ShadowOffset",Range(-1,1)) = 0
        _lineRange("lineRange",Range(0.19,0.2025))=0.20249
        _lineAlpha("lineAlpha",Range(0,1)) = 1
        _lineColor("lineColor",Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 100

         pass
        {
            Name "Outline"
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 normal : NORMAL;
            };


            bool _Outline;
            float _OutlineStrength;
            fixed4 _OutlineColor;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                v.vertex.xyz += v.normal * _OutlineStrength *_Outline;
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(_OutlineColor.rgb,1);
            }
            ENDCG

        }

        Pass
        {
             Tags { "LightMode" = "ForwardBase" }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

        

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float4 alphaBlend(float4 top, float4 bottom)
            {
                float3 color = (top.rgb * top.a)+(bottom.rgb * (1-top.a));
                float alpha = top.a + bottom.a * (1-top.a);
                return float4(color,alpha);
            }

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uvbody : TEXCOORD4;
                float3 normal : Normal;
                fixed3 hatchWeight0 : TEXCOORD1;
                fixed3 hatchWeight1 : TEXCOORD2;
                float3 worldPos :TEXCOORD3;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uvbody : TEXCOORD4;
                float4 vertex : SV_POSITION;
                float3 normal : Normal;
                fixed3 hatchWeight0 : TEXCOORD1;
                fixed3 hatchWeight1 : TEXCOORD2;
                float3 worldPos :TEXCOORD3;
            };

            sampler2D _MainTex;
            sampler2D _EmissionTex;
            //float4 _MainTex_ST;
            sampler2D _Hatch0;
            sampler2D _Hatch1;
            sampler2D _Hatch2;
            sampler2D _Hatch3;
            sampler2D _Hatch4;
            sampler2D _Hatch5;
            float _TileFactor;
            fixed4 _Color;
            fixed4 _Shadowcol;
            float _ShadowSmooth;
            float _ShadowAlpha;
            float _lightRange;
            float _ShadowOffset;
            float _lineRange;
            float _lineOffset;
            fixed _lineAlpha;
            fixed4 _lineColor,_EmissionCol;
            

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv.xy ;
                o.uvbody = v.uvbody;
                o.normal = mul(unity_ObjectToWorld,v.normal).xyz;

                fixed3 worldLightDir = normalize(WorldSpaceLightDir(v.vertex));
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed diff = max(0,dot(worldLightDir,worldNormal));

                o.hatchWeight0 = fixed3(0,0,0);
                o.hatchWeight1 = fixed3(0,0,0);

                float hatchFactor = diff *7.0 + _lightRange;

                if(hatchFactor >6.0){

                } else if (hatchFactor >5.0){
                    o.hatchWeight0.x = hatchFactor - 5.0;
                } else if (hatchFactor >4.0){
                    o.hatchWeight0.x = hatchFactor - 4.0;
                    o.hatchWeight0.y = 1-o.hatchWeight0.x;
                } else if (hatchFactor >3.0){
                    o.hatchWeight0.y = hatchFactor - 3.0;
                    o.hatchWeight0.z = 1-o.hatchWeight0.y;
                } else if (hatchFactor >2.0){
                    o.hatchWeight0.z = hatchFactor - 2.0;
                    o.hatchWeight1.x = 1-o.hatchWeight0.z;
                } else if (hatchFactor >1.0){
                    o.hatchWeight1.x = hatchFactor - 1.0;
                    o.hatchWeight1.y = 1-o.hatchWeight1.x;
                } else {
                    o.hatchWeight1.y = hatchFactor;
                    o.hatchWeight1.z = 1-o.hatchWeight1.y;
                }

                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;   

                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                //sketchshadow
                fixed4 hatchTex0 = tex2D(_Hatch0,i.uv*_TileFactor) * i.hatchWeight0.x;
                fixed4 hatchTex1 = tex2D(_Hatch1,i.uv*_TileFactor) * i.hatchWeight0.y;
                fixed4 hatchTex2 = tex2D(_Hatch2,i.uv*_TileFactor) * i.hatchWeight0.z;
                fixed4 hatchTex3 = tex2D(_Hatch3,i.uv*_TileFactor) * i.hatchWeight1.x;
                fixed4 hatchTex4 = tex2D(_Hatch4,i.uv*_TileFactor) * i.hatchWeight1.y;
                fixed4 hatchTex5 = tex2D(_Hatch5,i.uv*_TileFactor) * i.hatchWeight1.z;
                fixed4 whiteColor = fixed4(1,1,1,1) * (1-i.hatchWeight0.x - i.hatchWeight0.y - i.hatchWeight0.z - i.hatchWeight1.x - i.hatchWeight1.y - i.hatchWeight1.z);


                //shadow
                fixed4 hatchColor = hatchTex0 + hatchTex1 + hatchTex2 + hatchTex3 + hatchTex4 + hatchTex5 + whiteColor;
                fixed4 shadow = (1-hatchColor) *_Shadowcol;
                float intensity = dot(_WorldSpaceLightPos0,i.normal);
                intensity = smoothstep(0,_ShadowSmooth,intensity);
                intensity = 1-intensity;
                intensity-=_ShadowAlpha;
                intensity = clamp(0,1,intensity);
                intensity = saturate(abs(1-intensity));

                //line
                float intensitytwo = saturate(2*dot(_WorldSpaceLightPos0,i.normal)-_ShadowOffset);
                float lineone= saturate(2*dot(_WorldSpaceLightPos0,i.normal)-_ShadowOffset + 0.1);
                float linetwo = intensitytwo * (1-lineone);
                linetwo = step(linetwo,_lineRange);
                linetwo = saturate(linetwo +_lineAlpha);

                fixed4 emissionsTex = tex2D(_EmissionTex,i.uv) * _EmissionCol;

                _lineColor.a *=(1-linetwo);

                fixed4 finaltex = tex2D(_MainTex,i.uvbody);
                fixed4 finalcol = fixed4(shadow + hatchColor * _Color * finaltex * intensity);
                
                return alphaBlend(_lineColor,finalcol)+emissionsTex;
                
            }
            ENDCG
        }
    }
}
