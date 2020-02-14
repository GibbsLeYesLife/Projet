// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cours_M1_2020/Basic/Normal"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		_Metallic_Texture("Metallic_Texture", 2D) = "white" {}
		_Roughness_Texture("Roughness_Texture", 2D) = "white" {}
		_Normal_Texture("Normal_Texture", 2D) = "white" {}
		_Roughness("Roughness", Range( 0 , 1)) = 0.5
		_Normal_Scale("Normal_Scale", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
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
		uniform sampler2D _Metallic_Texture;
		uniform sampler2D _Roughness_Texture;
		uniform float _Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Main_Texture = i.uv_texcoord * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal_Texture, uv_Main_Texture ), _Normal_Scale );
			o.Albedo = tex2D( _Main_Texture, uv_Main_Texture ).rgb;
			o.Metallic = tex2D( _Metallic_Texture, uv_Main_Texture ).r;
			float4 tex2DNode10 = tex2D( _Roughness_Texture, uv_Main_Texture );
			float4 temp_cast_3 = (_Roughness).xxxx;
			float4 blendOpSrc13 = tex2DNode10;
			float4 blendOpDest13 = temp_cast_3;
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
482;513;1077;466;2131.337;-471.0818;2.349627;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-918.3016,131.5786;Float;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;9;-964.8221,499.8645;Float;True;Property;_Roughness_Texture;Roughness_Texture;2;0;Create;True;0;0;False;0;d95143cc36b529147bb441f1af2d0a5f;d95143cc36b529147bb441f1af2d0a5f;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-650.8101,769.2949;Float;False;Property;_Roughness;Roughness;4;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-577.1528,519.2482;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1162.918,888.8857;Float;True;Property;_Normal_Texture;Normal_Texture;3;0;Create;True;0;0;False;0;d23e1f1349882aa47a271faf1b7e4932;d23e1f1349882aa47a271faf1b7e4932;True;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-666.3159,-70.00939;Float;True;Property;_Main_Texture;Main_Texture;0;0;Create;True;0;0;False;0;ac5282c54e0314849ba913c321c46746;ac5282c54e0314849ba913c321c46746;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-937.6849,290.5231;Float;True;Property;_Metallic_Texture;Metallic_Texture;1;0;Create;True;0;0;False;0;416f9684bf768c44cbb4f77c41c5133d;416f9684bf768c44cbb4f77c41c5133d;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.BlendOpsNode;13;-214.6818,827.4454;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-562.3032,1097.084;Float;False;Property;_Normal_Scale;Normal_Scale;5;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-793.9958,889.3415;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-203.052,563.8301;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-296.0914,-17.67402;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-526.7556,205.2358;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;21.79776,404.8854;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;16;-297.019,938.0795;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;201.588,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Cours_M1_2020/Basic/Normal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;0
WireConnection;10;1;3;0
WireConnection;13;0;10;0
WireConnection;13;1;11;0
WireConnection;15;0;14;0
WireConnection;15;1;3;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;7;0;8;0
WireConnection;7;1;3;0
WireConnection;6;0;13;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;0;0;1;0
WireConnection;0;1;16;0
WireConnection;0;3;7;0
WireConnection;0;4;6;0
ASEEND*/
//CHKSM=52AE5E41C62B426685164F13FCDB614160490E77