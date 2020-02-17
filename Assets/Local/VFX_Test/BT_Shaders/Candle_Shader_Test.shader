// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Candle_Shader_Test"
{
	Properties
	{
		_Candle_Fire("Candle_Fire", 2D) = "white" {}
		_zanimatedperlin("z-animated-perlin", 2D) = "white" {}
		_BurnIntensity("BurnIntensity", Float) = 10
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+1" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Candle_Fire;
		uniform sampler2D _zanimatedperlin;
		uniform float _BurnIntensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix ));
			v.vertex.x *= length( unity_ObjectToWorld._m00_m10_m20 );
			v.vertex.y *= length( unity_ObjectToWorld._m01_m11_m21 );
			v.vertex.z *= length( unity_ObjectToWorld._m02_m12_m22 );
			v.vertex = mul( v.vertex, rotationCamMatrix );
			v.vertex.xyz += unity_ObjectToWorld._m03_m13_m23;
			//Need to nullify rotation inserted by generated surface shader;
			v.vertex = mul( unity_WorldToObject, v.vertex );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 appendResult11 = (float3(-0.1 , -0.1 , 0.0));
			float4 transform59 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 paralaxOffset60 = ParallaxOffset( 1 , 1 , transform59.xyz );
			float2 uv_TexCoord4 = i.uv_texcoord + paralaxOffset60;
			float2 panner5 = ( 1.0 * _Time.y * appendResult11.xy + ( uv_TexCoord4 * 0.1 ));
			float4 Noise71 = tex2D( _zanimatedperlin, panner5 );
			float4 color26 = IsGammaSpace() ? float4(1,0.404888,0.240566,0) : float4(1,0.1363198,0.04718075,0);
			float4 Flicker73 = ( tex2D( _Candle_Fire, ( i.uv_texcoord + ( i.uv_texcoord.y * ( (Noise71).rg - float2( 0.22,0.19 ) ) ) ) ) * color26 );
			o.Emission = ( pow( Flicker73 , 1.0 ) * _BurnIntensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
81;393;1188;506;154.4787;82.95772;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;69;-1821.853,-304.462;Float;False;1967.032;707.4034;Noise;11;59;16;60;17;4;11;5;18;10;15;71;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;59;-1771.853,-177.17;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1376.233,94.43958;Float;False;Constant;_SpeedPann;Speed Pann;2;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;60;-1602.642,48.99064;Float;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1189.158,-236.4884;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1143.013,305.9153;Float;False;Constant;_NoiseSize;Noise Size;2;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;17;-1170.67,99.50476;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-880.752,-141.8273;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-950.0411,97.79456;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;5;-736.0465,-0.3090191;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;18;-496.7766,-7.833092;Float;True;Property;_zanimatedperlin;z-animated-perlin;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;72;-779.5338,320.7712;Float;False;1444.644;526.6554;Flicker;10;70;21;22;19;23;20;1;26;27;73;Flicker;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-128.1289,65.29707;Float;True;Noise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-758.6039,384.9307;Float;False;71;Noise;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;21;-640.1304,516.731;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-476.624,668.8511;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.22,0.19;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-408.2552,373.1936;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-270.1285,581.7512;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-99.89069,453.0996;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;38.88763,374.2258;Float;True;Property;_Candle_Fire;Candle_Fire;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;-60.8985,642.849;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;1,0.404888,0.240566,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;372.2502,498.8126;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;451.0704,676.0007;Float;False;Flicker;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;75;214.5936,-33.3925;Float;False;652.0796;394.404;Burn;4;66;67;74;68;Burn;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;264.5939,16.60744;Float;False;73;Flicker;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;68;530.468,246.0117;Float;False;Property;_BurnIntensity;BurnIntensity;3;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;66;506.3086,26.11042;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;697.6735,28.20041;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;64;947.8566,82.48309;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Candle_Shader_Test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;1;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;True;Cylindrical;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;2;59;0
WireConnection;4;1;60;0
WireConnection;17;0;16;0
WireConnection;10;0;4;0
WireConnection;10;1;15;0
WireConnection;11;0;17;0
WireConnection;11;1;17;0
WireConnection;5;0;10;0
WireConnection;5;2;11;0
WireConnection;18;1;5;0
WireConnection;71;0;18;0
WireConnection;21;0;70;0
WireConnection;22;0;21;0
WireConnection;23;0;19;2
WireConnection;23;1;22;0
WireConnection;20;0;19;0
WireConnection;20;1;23;0
WireConnection;1;1;20;0
WireConnection;27;0;1;0
WireConnection;27;1;26;0
WireConnection;73;0;27;0
WireConnection;66;0;74;0
WireConnection;67;0;66;0
WireConnection;67;1;68;0
WireConnection;64;2;67;0
ASEEND*/
//CHKSM=A3CB88E8C10F5D667054F3C46FC5CF74559B9D06