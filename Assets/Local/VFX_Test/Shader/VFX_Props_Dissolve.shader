// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Props_Dissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Dissolve("Dissolve", Range( -10 , 10)) = 0
		_SmoothStep_2("SmoothStep_2", Float) = 0.26
		_Edge_Size_1("Edge_Size_1", Float) = 0.26
		[HDR]_Emissive_Color_1("Emissive_Color_1", Color) = (2.45283,0.242969,0.242969,0)
		_Main_Noise_Tile("Main_Noise_Tile", Vector) = (1,1,0,0)
		_Tile_Second("Tile_Second", Vector) = (1,1,0,0)
		_Color_1_Power("Color_1_Power", Float) = 0
		_Main_Noise_Speed("Main_Noise_Speed", Vector) = (0,0,0,0)
		_Distortion("Distortion", 2D) = "white" {}
		_Speed_Second("Speed_Second", Vector) = (0,0,0,0)
		_Distortion_Factor("Distortion_Factor", Range( 0 , 0.2)) = 0.06145984
		_T_Lu_Noise_02("T_Lu_Noise_02", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Distortion_Tile("Distortion_Tile", Vector) = (0,0,0,0)
		_Distortion_Speed("Distortion_Speed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Color_1_Power;
		uniform float4 _Emissive_Color_1;
		uniform float _Edge_Size_1;
		uniform float _SmoothStep_2;
		uniform sampler2D _T_Lu_Noise_02;
		uniform float2 _Main_Noise_Tile;
		uniform float2 _Main_Noise_Speed;
		uniform float _Distortion_Factor;
		uniform sampler2D _Distortion;
		uniform float2 _Distortion_Speed;
		uniform float2 _Distortion_Tile;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tile_Second;
		uniform float2 _Speed_Second;
		uniform float _Dissolve;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner39 = ( 1.0 * _Time.y * _Main_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord44 = i.uv_texcoord * _Main_Noise_Tile + panner39;
			float2 uv_TexCoord70 = i.uv_texcoord * _Distortion_Tile;
			float2 panner65 = ( 1.0 * _Time.y * _Distortion_Speed + uv_TexCoord70);
			float Distortion71 = ( _Distortion_Factor * (-0.5 + (tex2D( _Distortion, panner65 ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) );
			float2 panner59 = ( 1.0 * _Time.y * _Speed_Second + float2( 0,0 ));
			float2 uv_TexCoord60 = i.uv_texcoord * _Tile_Second + panner59;
			float Noise50 = ( ( tex2D( _T_Lu_Noise_02, uv_TexCoord44 ).b + Distortion71 ) + ( Distortion71 + tex2D( _TextureSample0, uv_TexCoord60 ).g ) );
			float temp_output_6_0 = ( Noise50 + _Dissolve );
			float smoothstepResult74 = smoothstep( _Edge_Size_1 , _SmoothStep_2 , temp_output_6_0);
			o.Emission = ( ( _Color_1_Power + _Emissive_Color_1 ) * ( 1.0 - smoothstepResult74 ) ).rgb;
			o.Alpha = 1;
			clip( temp_output_6_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
439;489;1077;474;5077.488;1707.608;4.259146;True;False
Node;AmplifyShaderEditor.CommentaryNode;81;-4180.876,-1585.825;Float;False;2293.936;824.1744;Comment;9;72;70;65;66;68;67;69;71;73;Disto;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;72;-4130.876,-1210.612;Float;False;Property;_Distortion_Tile;Distortion_Tile;14;0;Create;True;0;0;False;0;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-3762.042,-1372.691;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;73;-3779.229,-1065.651;Float;False;Property;_Distortion_Speed;Distortion_Speed;15;0;Create;True;0;0;False;0;0,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;65;-3427.779,-1349.852;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;66;-3168.207,-1306.405;Float;True;Property;_Distortion;Distortion;9;0;Create;True;0;0;False;0;1cc7c8f54ac3f934eaf70c0e7a831a64;790068d4715e9e744a4a737a78ac2d22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;82;-4141.203,-605.373;Float;False;2139.652;1237.922;Comment;15;37;57;39;41;58;59;60;44;46;78;61;79;80;62;50;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2718.601,-1535.825;Float;False;Property;_Distortion_Factor;Distortion_Factor;11;0;Create;True;0;0;False;0;0.06145984;0.1;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;67;-2787.57,-1286.39;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;37;-3946.357,-231.3845;Float;False;Property;_Main_Noise_Speed;Main_Noise_Speed;8;0;Create;True;0;0;False;0;0,0;0.1,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;57;-4091.203,328.5498;Float;False;Property;_Speed_Second;Speed_Second;10;0;Create;True;0;0;False;0;0,0;-0.1,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;59;-3854.717,274.3368;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2423.825,-1268.32;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;58;-3768.934,8.418753;Float;False;Property;_Tile_Second;Tile_Second;6;0;Create;True;0;0;False;0;1,1;5,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;41;-3677.827,-555.373;Float;False;Property;_Main_Noise_Tile;Main_Noise_Tile;5;0;Create;True;0;0;False;0;1,1;5,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;39;-3709.872,-285.5977;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2129.941,-1261.908;Float;False;Distortion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-3511.913,85.516;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-3367.066,-474.4195;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;-3009.337,187.9818;Float;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;False;0;0478464d893083343b931277de9268e0;1b3691f44acf81a40b94c25af643e0ba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2992.123,-122.7495;Float;False;71;Distortion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-2956.774,-480.2099;Float;True;Property;_T_Lu_Noise_02;T_Lu_Noise_02;12;0;Create;True;0;0;False;0;0478464d893083343b931277de9268e0;683786ba771ae1d4791af11335fd2501;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2712.076,126.1657;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2550.638,-353.3344;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-2493.098,-25.36777;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-1945.382,-251.575;Float;False;1328.122;817.7017;Comment;6;74;54;3;9;76;6;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2244.551,98.85158;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1895.382,293.4294;Float;False;Property;_Dissolve;Dissolve;1;0;Create;True;0;0;False;0;0;0.3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1858.501,-191.3608;Float;False;50;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1138.165,308.1267;Float;False;Property;_SmoothStep_2;SmoothStep_2;2;0;Create;True;0;0;False;0;0.26;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-635.0023,-664.9808;Float;False;1276.201;861.9977;Comment;5;17;12;16;77;14;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-1466.986,-10.38153;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1243.143,122.8584;Float;False;Property;_Edge_Size_1;Edge_Size_1;3;0;Create;True;0;0;False;0;0.26;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-585.0023,-518.7883;Float;False;Property;_Emissive_Color_1;Emissive_Color_1;4;1;[HDR];Create;True;0;0;False;0;2.45283,0.242969,0.242969,0;0.4879977,2.394382,4.90566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-176.1555,-614.9808;Float;False;Property;_Color_1_Power;Color_1_Power;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-873.2607,-201.575;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;77;156.8853,-96.09002;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;10.0337,-389.3896;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;406.1982,-55.98336;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;687.7981,-94.61464;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;VFX_Props_Dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;0;72;0
WireConnection;65;0;70;0
WireConnection;65;2;73;0
WireConnection;66;1;65;0
WireConnection;67;0;66;1
WireConnection;59;2;57;0
WireConnection;69;0;68;0
WireConnection;69;1;67;0
WireConnection;39;2;37;0
WireConnection;71;0;69;0
WireConnection;60;0;58;0
WireConnection;60;1;59;0
WireConnection;44;0;41;0
WireConnection;44;1;39;0
WireConnection;61;1;60;0
WireConnection;46;1;44;0
WireConnection;80;0;78;0
WireConnection;80;1;61;2
WireConnection;79;0;46;3
WireConnection;79;1;78;0
WireConnection;62;0;79;0
WireConnection;62;1;80;0
WireConnection;50;0;62;0
WireConnection;6;0;54;0
WireConnection;6;1;3;0
WireConnection;74;0;6;0
WireConnection;74;1;9;0
WireConnection;74;2;76;0
WireConnection;77;0;74;0
WireConnection;17;0;16;0
WireConnection;17;1;12;0
WireConnection;14;0;17;0
WireConnection;14;1;77;0
WireConnection;0;2;14;0
WireConnection;0;10;6;0
ASEEND*/
//CHKSM=0BE704126F9DA09C5E02B8C59A40B1D664C109D4