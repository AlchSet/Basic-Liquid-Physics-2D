// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit alpha-cutout shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Custom/Transparent Cutout DISTORT" {
	Properties{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}

		[Normal] _DistortTexture("Distort Texture", 2D) = "Bump"{}
		_DistortionAmount("Distort Amount",float) = 0

		_ScrollX("ScrollSpeed X",float)=0
		_ScrollY("ScrollSpeed Y",float)=0

		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
		_Color("Main color", Color) = (1,1,1,1)

		_Stroke("Stroke alpha", Range(0,1)) = 0.1
		_StrokeColor("Stroke color", Color) = (1,1,1,1)

	}
		SubShader{
			Tags {"Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout"}
			LOD 100
		//Blend DstColor One
		Blend SrcAlpha OneMinusSrcAlpha
		Lighting Off
			ZWrite Off
			 Cull Off
		ZTest Always
			
			GrabPass
			{
			"_GrabTexture"
			}



		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_fog

				#include "UnityCG.cginc"





				struct appdata_t {
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
					float4 color : COLOR;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f {
					float4 vertex : SV_POSITION;
					float2 texcoord : TEXCOORD0;
					float2 distortionUV : TEXCOORD1;
					float4 grabPassUV : TEXCOORD2;
					float4 color : COLOR;


					UNITY_FOG_COORDS(1)
					UNITY_VERTEX_OUTPUT_STEREO
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				sampler2D _DistortTexture;
				float4 _DistortTexture_ST;


				float _ScrollX;
				float _ScrollY;

				fixed _Cutoff;
				half4 _Color;
				fixed _Stroke;
				half4 _StrokeColor;
				float stroke;

				float _DistortionAmount;
				
				sampler2D _GrabTexture;




				v2f vert(appdata_t v)
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.distortionUV = TRANSFORM_TEX(v.texcoord, _DistortTexture);
					o.grabPassUV = ComputeGrabScreenPos(o.vertex);
					o.color = v.color;
					UNITY_TRANSFER_FOG(o,o.vertex);

					o.distortionUV.xy = o.distortionUV.xy + frac(_Time.y * float2(_ScrollX, _ScrollY));

					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{


					fixed4 col = tex2D(_MainTex, i.texcoord);
					clip(col.a - _Cutoff);

					if (col.a < _Stroke) {
						col = _StrokeColor;
						stroke = 1;
					}
					else {
						col = _Color;
						stroke = 0;
					}

					UNITY_APPLY_FOG(i.fogCoord, col);



					//Use this to have outer color opaque
					if (stroke == 0)
					{
						col.a = _Color.a;
					}


					//fixed mask = tex2D(_MainTex, i.texcoord).x;
					float2 distortion = UnpackNormal(tex2D(_DistortTexture, i.distortionUV)).xy;
					
					distortion *= _DistortionAmount * col.x * i.color.a;
					i.grabPassUV.xy += distortion * i.grabPassUV.z;

					col =(col*_Color)* tex2Dproj(_GrabTexture, i.grabPassUV);
					col.a=_Color.a;



					//clip(col.a - _Cutoff);

					//col=col*tex2Dproj(_GrabTexture, i.grabPassUV)+_Color;

					if (stroke == 1)
					{
						col = _StrokeColor;
					}


				return col;
			}
		ENDCG
	}
	}

}
