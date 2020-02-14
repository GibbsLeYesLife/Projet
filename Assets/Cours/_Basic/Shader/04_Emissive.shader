// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cours_M1_2020/Basic/Emissive"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		_Metallic_Texture("Metallic_Texture", 2D) = "white" {}
		_Roughness_Texture("Roughness_Texture", 2D) = "white" {}
		_Normal_Texture("Normal_Texture", 2D) = "white" {}
		_Emissive("Emissive", 2D) = "white" {}
		_Roughness("Roughness", Range( 0 , 1)) = 0.5
		_Normal_Scale("Normal_Scale", Range( 0 , 1)) = 1
		[HDR]_Emissive_Color("Emissive_Color", Color) = (0.6415094,0.06354574,0.06354574,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal_Texture;
		uniform sampler2D _Main_Texture;
		uniform float4 _Main_Texture_ST;
		uniform float _Normal_Scale;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_Color;
		uniform sampler2D _Metallic_Texture;
		uniform sampler2D _Roughness_Texture;
		uniform float _Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Main_Texture = i.uv_texcoord * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal_Texture, uv_Main_Texture ), _Normal_Scale );
			o.Albedo = tex2D( _Main_Texture, uv_Main_Texture ).rgb;
			o.Emission = ( tex2D( _Emissive, uv_Main_Texture ) * _Emissive_Color ).rgb;
			o.Metallic = tex2D( _Metallic_Texture, uv_Main_Texture ).r;
			float4 temp_cast_4 = (_Roughness).xxxx;
			float4 blendOpSrc13 = tex2D( _Roughness_Texture, uv_Main_Texture );
			float4 blendOpDest13 = temp_cast_4;
			o.Smoothness = ( 1.0 - ( saturate( (( blendOpDest13 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest13 - 0.5 ) ) * ( 1.0 - blendOpSrc13 ) ) : ( 2.0 * blendOpDest13 * blendOpSrc13 ) ) )) ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
407;504;1077;466;3193.442;504.4529;4.034912;True;False
Node;AmplifyShaderEditor.CommentaryNode;23;-926.9373,-290.1513;Float;False;840.2952;691.2889;Comment;4;8;7;9;10;Metallic/Roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1629.291,332.114;Float;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;24;-905.1581,468.6897;Float;False;891.1194;217.7811;Comment;3;6;13;11;Roughness_Control;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-865.1639,79.0023;Float;True;Property;_Roughness_Texture;Roughness_Texture;2;0;Create;True;0;0;False;0;d95143cc36b529147bb441f1af2d0a5f;d95143cc36b529147bb441f1af2d0a5f;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1256.774,1111.644;Float;False;1244.016;492.3087;Comment;4;18;19;20;21;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1270.576,725.6292;Float;False;1179.899;373.1983;Comment;4;14;15;17;16;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;-721.5295,-678.6774;Float;False;793.1714;299.8685;Node to input albedo;2;2;1;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1220.576,775.6292;Float;True;Property;_Normal_Texture;Normal_Texture;3;0;Create;True;0;0;False;0;d23e1f1349882aa47a271faf1b7e4932;d23e1f1349882aa47a271faf1b7e4932;True;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-855.158,571.471;Float;False;Property;_Roughness;Roughness;5;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1206.774,1161.644;Float;True;Property;_Emissive;Emissive;4;0;Create;True;0;0;False;0;e92e780a876fb3043819b47f98d55fea;e92e780a876fb3043819b47f98d55fea;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;10;-464.9516,75.80784;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;2;-671.5295,-628.6774;Float;True;Property;_Main_Texture;Main_Texture;0;0;Create;True;0;0;False;0;ac5282c54e0314849ba913c321c46746;ac5282c54e0314849ba913c321c46746;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.BlendOpsNode;13;-486.821,518.6898;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-619.961,983.8276;Float;False;Property;_Normal_Scale;Normal_Scale;6;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-851.6536,776.085;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-837.8519,1176.198;Float;True;Property;_TextureSample4;Texture Sample 4;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;8;-876.9374,-232.6851;Float;True;Property;_Metallic_Texture;Metallic_Texture;1;0;Create;True;0;0;False;0;416f9684bf768c44cbb4f77c41c5133d;416f9684bf768c44cbb4f77c41c5133d;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;20;-826.7809,1396.953;Float;False;Property;_Emissive_Color;Emissive_Color;7;1;[HDR];Create;True;0;0;False;0;0.6415094,0.06354574,0.06354574,0;4.237095,1.380151,0.0665511,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-201.039,519.3125;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-181.7579,1182.324;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;16;-354.677,824.8231;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;7;-407.6423,-240.1512;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-249.3581,-608.809;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;201.588,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Cours_M1_2020/Basic/Emissive;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;0
WireConnection;10;1;3;0
WireConnection;13;0;10;0
WireConnection;13;1;11;0
WireConnection;15;0;14;0
WireConnection;15;1;3;0
WireConnection;19;0;18;0
WireConnection;19;1;3;0
WireConnection;6;0;13;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;7;0;8;0
WireConnection;7;1;3;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;0;0;1;0
WireConnection;0;1;16;0
WireConnection;0;2;21;0
WireConnection;0;3;7;0
WireConnection;0;4;6;0
ASEEND*/
//CHKSM=F4FBB053A08EF49B85B07D415243F5D74A97F047