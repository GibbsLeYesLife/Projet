// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Build_Up_Trail"
{
	Properties
	{
		_Tiling_Noise_Secondary("Tiling_Noise_Secondary", Vector) = (0,0,0,0)
		_Tiling_Noise_1("Tiling_Noise_1", Vector) = (1,1,0,0)
		_T_Lu_Noise_01("T_Lu_Noise_01", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _T_Lu_Noise_01;
		uniform float2 _Tiling_Noise_1;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tiling_Noise_Secondary;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color15 = IsGammaSpace() ? float4(0.6355834,2.248082,1.412343,0) : float4(0.3616703,5.94274,2.137315,0);
			float2 uv_TexCoord11 = i.uv_texcoord * _Tiling_Noise_1;
			float2 uv_TexCoord12 = i.uv_texcoord * _Tiling_Noise_Secondary;
			float Noise4 = ( tex2D( _T_Lu_Noise_01, uv_TexCoord11 ).r + tex2D( _TextureSample0, uv_TexCoord12 ).r );
			float4 temp_output_16_0 = ( color15 * Noise4 );
			o.Emission = temp_output_16_0.rgb;
			o.Alpha = temp_output_16_0.r;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
989;540;973;534;2097.885;1400.236;2.028876;True;False
Node;AmplifyShaderEditor.Vector2Node;8;-1701.974,-994.213;Float;False;Property;_Tiling_Noise_1;Tiling_Noise_1;1;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;10;-1806.08,-440.692;Float;False;Property;_Tiling_Noise_Secondary;Tiling_Noise_Secondary;0;0;Create;True;0;0;False;0;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1443.231,-885.701;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1506.683,-339.67;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-1200.402,-274.368;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;-1;6ca5b2e608f86e14d88db87d75ba2f41;c3a812bedf42c56439718330cacc6483;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-836.0059,-1079.389;Inherit;True;Property;_T_Lu_Noise_01;T_Lu_Noise_01;4;0;Create;True;0;0;False;0;-1;6ca5b2e608f86e14d88db87d75ba2f41;3ef2750b38b3bf24492daf58c7ec2b57;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-797.5551,-491.0911;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-293.3307,-420.0873;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-150.4942,-87.48376;Inherit;False;4;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;52.83476,-356.5254;Inherit;False;Constant;_Color_Main;Color_Main;6;1;[HDR];Create;True;0;0;False;0;0.6355834,2.248082,1.412343,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;24;-612.4005,267.1177;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-2022.523,-642.667;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;2;0;Create;True;0;0;False;0;3,1;-2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;33.45846,146.9715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-991.6777,159.0845;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;-1;None;e0c51c9d580b0f446b5cc88d1b107a72;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-1850.789,-150.85;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;6;-2083.513,-171.0079;Float;False;Property;_Speed_Noise_Secondary;Speed_Noise_Secondary;3;0;Create;True;0;0;False;0;0,0;-0.5,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;166.7774,-176.1163;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;7;-1786.036,-696.88;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;540.1771,-103.1148;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Build_Up_Trail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;8;0
WireConnection;12;0;10;0
WireConnection;13;1;12;0
WireConnection;1;1;11;0
WireConnection;2;0;1;1
WireConnection;2;1;13;1
WireConnection;4;0;2;0
WireConnection;24;0;22;1
WireConnection;20;0;14;0
WireConnection;9;2;6;0
WireConnection;16;0;15;0
WireConnection;16;1;14;0
WireConnection;7;2;5;0
WireConnection;0;2;16;0
WireConnection;0;9;16;0
ASEEND*/
//CHKSM=8875E271FC18F1778FF91C219C90679C384B5B30