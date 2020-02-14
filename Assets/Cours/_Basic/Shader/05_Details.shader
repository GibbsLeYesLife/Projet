// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cours_M1_2020/Basic/Details"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		_Metallic_MRA("Metallic_MRA", 2D) = "white" {}
		_Normal_Texture("Normal_Texture", 2D) = "white" {}
		_Emissive("Emissive", 2D) = "white" {}
		_Details_Albedo("Details_Albedo", 2D) = "white" {}
		_Details_Normal("Details_Normal", 2D) = "white" {}
		_Roughness("Roughness", Range( 0 , 1)) = 0.5
		_Normal_Scale("Normal_Scale", Range( 0 , 1)) = 1
		[HDR]_Emissive_Color("Emissive_Color", Color) = (0.6415094,0.06354574,0.06354574,0)
		_Detail_Normal_Int("Detail_Normal_Int", Int) = 5
		_Details("Details", Range( 0 , 1)) = 0
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
		uniform sampler2D _Details_Normal;
		uniform int _Detail_Normal_Int;
		uniform float _Details;
		uniform sampler2D _Details_Albedo;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_Color;
		uniform sampler2D _Metallic_MRA;
		uniform float _Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Main_Texture = i.uv_texcoord * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			o.Normal = BlendNormals( UnpackScaleNormal( tex2D( _Normal_Texture, uv_Main_Texture ), _Normal_Scale ) , UnpackScaleNormal( tex2D( _Details_Normal, i.uv_texcoord ), (float)_Detail_Normal_Int ) );
			o.Albedo = ( tex2D( _Main_Texture, uv_Main_Texture ) * saturate( ( ( 1.0 - _Details ) + saturate( ( 2.0 * tex2D( _Details_Albedo, i.uv_texcoord ) ) ) ) ) ).rgb;
			o.Emission = ( tex2D( _Emissive, uv_Main_Texture ) * _Emissive_Color ).rgb;
			float4 tex2DNode7 = tex2D( _Metallic_MRA, uv_Main_Texture );
			o.Metallic = tex2DNode7.r;
			float blendOpSrc13 = tex2DNode7.g;
			float blendOpDest13 = _Roughness;
			o.Smoothness = ( 1.0 - ( saturate( (( blendOpDest13 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest13 - 0.5 ) ) * ( 1.0 - blendOpSrc13 ) ) : ( 2.0 * blendOpDest13 * blendOpSrc13 ) ) )) );
			o.Occlusion = tex2DNode7.b;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
309;519;1077;498;1451.305;-1647.114;1.45942;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1362.582,1858.748;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;27;-1091.448,1710.919;Float;True;Property;_Details_Albedo;Details_Albedo;4;0;Create;True;0;0;False;0;None;7e3608fad768ed6448d439d87d7a175d;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-412.7698,1695.121;Float;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-730.0671,1712.904;Float;True;Property;_TextureSample5;Texture Sample 5;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;25;-1270.576,725.6292;Float;False;1179.899;373.1983;Comment;4;14;15;17;16;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-269.1663,1766.923;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-149.0326,1686.34;Float;False;Property;_Details;Details;10;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-926.9373,-290.1513;Float;False;840.2952;691.2889;Comment;2;8;7;Metallic/Roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1719.668,472.7009;Float;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;40;-27.17035,1777.672;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1256.774,1111.644;Float;False;1244.016;492.3087;Comment;4;18;19;20;21;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;-721.5295,-678.6774;Float;False;793.1714;299.8685;Node to input albedo;2;2;1;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-876.9374,-232.6851;Float;True;Property;_Metallic_MRA;Metallic_MRA;1;0;Create;True;0;0;False;0;986b25e0aa0664a4982e259c4a2679b1;986b25e0aa0664a4982e259c4a2679b1;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1220.576,775.6292;Float;True;Property;_Normal_Texture;Normal_Texture;2;0;Create;True;0;0;False;0;d23e1f1349882aa47a271faf1b7e4932;d23e1f1349882aa47a271faf1b7e4932;True;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.OneMinusNode;45;174.7208,1696.749;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-905.1581,468.6897;Float;False;891.1194;217.7811;Comment;3;6;13;11;Roughness_Control;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;29;-1093.963,1956.52;Float;True;Property;_Details_Normal;Details_Normal;5;0;Create;True;0;0;False;0;None;de68399baf661324989b86ecddcccefb;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1206.774,1161.644;Float;True;Property;_Emissive;Emissive;3;0;Create;True;0;0;False;0;e92e780a876fb3043819b47f98d55fea;e92e780a876fb3043819b47f98d55fea;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.IntNode;35;-635.6317,2214.757;Float;False;Property;_Detail_Normal_Int;Detail_Normal_Int;9;0;Create;True;0;0;False;0;5;5;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-855.158,571.471;Float;False;Property;_Roughness;Roughness;6;0;Create;True;0;0;False;0;0.5;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-671.5295,-628.6774;Float;True;Property;_Main_Texture;Main_Texture;0;0;Create;True;0;0;False;0;ac5282c54e0314849ba913c321c46746;ac5282c54e0314849ba913c321c46746;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;328.3686,1757.513;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-619.961,983.8276;Float;False;Property;_Normal_Scale;Normal_Scale;7;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-732.5823,1964.268;Float;True;Property;_TextureSample6;Texture Sample 6;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-407.6423,-240.1512;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-851.6536,776.085;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;13;-486.821,518.6898;Float;False;Overlay;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;33;-341.9927,1972.417;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;44;516.1025,1756.582;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;16;-354.677,824.8231;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;19;-837.8519,1176.198;Float;True;Property;_TextureSample4;Texture Sample 4;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;-826.7809,1396.953;Float;False;Property;_Emissive_Color;Emissive_Color;8;1;[HDR];Create;True;0;0;False;0;0.6415094,0.06354574,0.06354574,0;2.996078,1.145098,0.1882353,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-249.3581,-608.809;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-181.7579,1182.324;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;6;-201.039,519.3125;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;37;185.1381,1024.964;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;454.6668,955.9434;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;721.493,3.733648;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Cours_M1_2020/Basic/Details;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;27;0
WireConnection;28;1;32;0
WireConnection;38;0;39;0
WireConnection;38;1;28;0
WireConnection;40;0;38;0
WireConnection;45;0;42;0
WireConnection;43;0;45;0
WireConnection;43;1;40;0
WireConnection;30;0;29;0
WireConnection;30;1;32;0
WireConnection;7;0;8;0
WireConnection;7;1;3;0
WireConnection;15;0;14;0
WireConnection;15;1;3;0
WireConnection;13;0;7;2
WireConnection;13;1;11;0
WireConnection;33;0;30;0
WireConnection;33;1;35;0
WireConnection;44;0;43;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;19;0;18;0
WireConnection;19;1;3;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;6;0;13;0
WireConnection;37;0;16;0
WireConnection;37;1;33;0
WireConnection;41;0;1;0
WireConnection;41;1;44;0
WireConnection;0;0;41;0
WireConnection;0;1;37;0
WireConnection;0;2;21;0
WireConnection;0;3;7;1
WireConnection;0;4;6;0
WireConnection;0;5;7;3
ASEEND*/
//CHKSM=B4C03C49C6E05E9D2E68EAD659F8D135FF7C34BA