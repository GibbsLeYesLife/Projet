// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dark_West_Outline"
{
	Properties
	{
		_Pack_01_Pack_01_AlbedoTransparency("Pack_01_Pack_01_AlbedoTransparency", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Pack_01_Pack_01_MetallicSmoothness("Pack_01_Pack_01_MetallicSmoothness", 2D) = "white" {}
		_Pack_01_Pack_01_Normal("Pack_01_Pack_01_Normal", 2D) = "white" {}
		_Largeur_Outline("Largeur_Outline", Float) = 0.05
		_Emissive("Emissive", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		
		struct Input
		{
			half filler;
		};
		uniform float _Largeur_Outline;
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _Largeur_Outline;
			v.vertex.xyz *= ( 1 + outlineVar);
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float4 color68 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			o.Emission = color68.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Pack_01_Pack_01_Normal;
		uniform float4 _Pack_01_Pack_01_Normal_ST;
		uniform sampler2D _Pack_01_Pack_01_AlbedoTransparency;
		uniform float4 _Pack_01_Pack_01_AlbedoTransparency_ST;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform sampler2D _Pack_01_Pack_01_MetallicSmoothness;
		uniform float4 _Pack_01_Pack_01_MetallicSmoothness_ST;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Pack_01_Pack_01_Normal = i.uv_texcoord * _Pack_01_Pack_01_Normal_ST.xy + _Pack_01_Pack_01_Normal_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Pack_01_Pack_01_Normal, uv_Pack_01_Pack_01_Normal ), 0.0 );
			float2 uv_Pack_01_Pack_01_AlbedoTransparency = i.uv_texcoord * _Pack_01_Pack_01_AlbedoTransparency_ST.xy + _Pack_01_Pack_01_AlbedoTransparency_ST.zw;
			float4 tex2DNode1 = tex2D( _Pack_01_Pack_01_AlbedoTransparency, uv_Pack_01_Pack_01_AlbedoTransparency );
			o.Albedo = tex2DNode1.rgb;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			o.Emission = tex2D( _Emissive, uv_Emissive ).rgb;
			float2 uv_Pack_01_Pack_01_MetallicSmoothness = i.uv_texcoord * _Pack_01_Pack_01_MetallicSmoothness_ST.xy + _Pack_01_Pack_01_MetallicSmoothness_ST.zw;
			float4 tex2DNode2 = tex2D( _Pack_01_Pack_01_MetallicSmoothness, uv_Pack_01_Pack_01_MetallicSmoothness );
			o.Metallic = tex2DNode2.r;
			o.Smoothness = tex2DNode2.a;
			o.Occlusion = tex2DNode2.g;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
586;295;973;528;-1976.876;557.5366;2.028495;True;False
Node;AmplifyShaderEditor.RangedFloatNode;60;2647.632,370.9763;Inherit;False;Property;_Largeur_Outline;Largeur_Outline;12;0;Create;True;0;0;False;0;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;2797.807,209.53;Inherit;False;Constant;_Color0;Color 0;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;37;-180.5376,-697.6501;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-115.7856,-1243.68;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;26;159.9958,270.8319;Inherit;False;Property;_Step_Value_2;Step_Value_2;9;0;Create;True;0;0;False;0;0.19;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;227.0195,-1432.501;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;38;-31.72361,-1541.013;Float;False;Constant;_Tiling_Noise_1;Tiling_Noise_1;2;0;Create;True;0;0;False;0;1,1;2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;31;1345.684,-28.27718;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;503.0497,-326.8303;Inherit;False;Property;_Color_Fresnel;Color_Fresnel;5;0;Create;True;0;0;False;0;1,0,0,0;0.6320754,0.2218988,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;2946.782,22.59429;Inherit;True;Property;_Pack_01_Pack_01_MetallicSmoothness;Pack_01_Pack_01_MetallicSmoothness;2;0;Create;True;0;0;False;0;-1;8c5a543e6b4080c48a3b76ed7af70ab1;8c5a543e6b4080c48a3b76ed7af70ab1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;163.5674,-886.4698;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;35;-413.2617,-717.8082;Float;False;Constant;_Speed_Noise_Secondary;Speed_Noise_Secondary;9;0;Create;True;0;0;False;0;0,-0.05;-1,-2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;67;2810.204,502.0535;Inherit;False;Constant;_Puissance_Noise_Outline;Puissance_Noise_Outline;13;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;25;498.3515,222.0145;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-118.2982,-155.2352;Inherit;False;Property;_Scale_Fresnel;Scale_Fresnel;4;0;Create;True;0;0;False;0;1;1.13;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;834.2444,-1626.189;Inherit;True;Property;_T_Lu_Noise_01;T_Lu_Noise_01;8;0;Create;True;0;0;False;0;-1;6ca5b2e608f86e14d88db87d75ba2f41;0751e6c0e52324d419f4ba807193701e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;2976.904,608.4481;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-88.48169,94.65485;Inherit;False;Property;_Power_Fresnel;Power_Fresnel;6;0;Create;True;0;0;False;0;10;10.6;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;638.9214,579.9858;Inherit;False;Property;_Color_Step;Color_Step;10;0;Create;True;0;0;False;0;0.7169812,0.510774,0.2063012,0;0.3411765,0.0585961,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;1970.263,-276.3728;Inherit;False;Constant;_Final_Float;Final_Float;13;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;2136.457,-31.54704;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;34;-352.2717,-1189.467;Float;False;Constant;_Speed_Noise_1;Speed_Noise_1;4;0;Create;True;0;0;False;0;0.05,0;1,-2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;69;3083.015,-181.827;Inherit;True;Property;_Emissive;Emissive;13;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;4;289.5965,-91.65381;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;432.6383,-863.6929;Inherit;True;Property;_Noise;Noise;11;0;Create;True;0;0;False;0;-1;6ca5b2e608f86e14d88db87d75ba2f41;1cc7c8f54ac3f934eaf70c0e7a831a64;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;36;-135.8296,-987.4919;Float;False;Constant;_Tiling_Noise_Secondary;Tiling_Noise_Secondary;0;0;Create;True;0;0;False;0;1,1;2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;63;2731.66,740.7834;Inherit;False;47;Noise_Pan;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;199.3445,497.8809;Inherit;False;Property;_Step_Value_1;Step_Value_1;7;0;Create;True;0;0;False;0;0.22;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;2578.523,-408.4148;Inherit;True;Property;_Pack_01_Pack_01_Normal;Pack_01_Pack_01_Normal;3;0;Create;True;0;0;False;0;-1;804388417e492ac40904f23370f3c69e;804388417e492ac40904f23370f3c69e;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;1164.349,-954.7649;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;1297.714,-590.8813;Inherit;False;Noise_Pan;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;1017.183,118.3623;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;1551.609,-263.2646;Inherit;False;47;Noise_Pan;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;3102.935,-555.512;Inherit;True;Property;_Pack_01_Pack_01_AlbedoTransparency;Pack_01_Pack_01_AlbedoTransparency;0;0;Create;True;0;0;False;0;-1;c01c57c689c016e43b8ea3d6accbe57d;c01c57c689c016e43b8ea3d6accbe57d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;743.4993,-109.2678;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;840.0318,383.3651;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;58;3069.248,281.8661;Inherit;False;1;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;1780.438,-24.6988;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3643.238,-257.2961;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Dark_West_Outline;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;2;35;0
WireConnection;39;2;34;0
WireConnection;40;0;38;0
WireConnection;40;1;39;0
WireConnection;31;0;27;0
WireConnection;41;0;36;0
WireConnection;41;1;37;0
WireConnection;25;0;4;0
WireConnection;25;1;26;0
WireConnection;25;2;19;0
WireConnection;42;1;40;0
WireConnection;65;0;67;0
WireConnection;65;1;63;0
WireConnection;54;0;52;0
WireConnection;54;1;50;0
WireConnection;4;2;8;0
WireConnection;4;3;9;0
WireConnection;43;1;41;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;47;0;44;0
WireConnection;27;0;7;0
WireConnection;27;1;29;0
WireConnection;7;0;6;0
WireConnection;7;1;4;0
WireConnection;29;0;25;0
WireConnection;29;1;28;0
WireConnection;58;0;68;0
WireConnection;58;1;60;0
WireConnection;50;0;49;0
WireConnection;50;1;31;0
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;2;69;0
WireConnection;0;3;2;1
WireConnection;0;4;2;4
WireConnection;0;5;2;2
WireConnection;0;10;1;4
WireConnection;0;11;58;0
ASEEND*/
//CHKSM=B294030547E78B40F6C198172C6DB0C8B0136784