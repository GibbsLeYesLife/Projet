// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water_Toon"
{
	Properties
	{
		[HDR]_Albedo("Albedo", Color) = (0.3372549,0.6117647,1.592157,0)
		[HDR]_Color_Global("Color_Global", Color) = (0,0.01166201,1,0)
		_Angle_Speed("Angle_Speed", Float) = 1
		_DistanceFade("Distance Fade", Range( 0 , 1)) = 0
		_Cell_Density("Cell_Density", Float) = 7
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HDR]_Ripple_Color("Ripple_Color", Color) = (0.8156863,2.917647,3.623529,0)
		_OffsetValue("OffsetValue", Float) = 0.5
		_Step_Intensity("Step_Intensity", Range( 0 , 10)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 5.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float eyeDepth;
		};

		uniform float _Cell_Density;
		uniform float _Angle_Speed;
		uniform float _OffsetValue;
		uniform float4 _Color_Global;
		uniform float4 _Albedo;
		uniform float _Step_Intensity;
		uniform float4 _Ripple_Color;
		uniform float _DistanceFade;
		uniform float _Smoothness;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;


		float2 voronoihash45( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi45( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash45( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float time45 = ( _Angle_Speed * _Time.y );
			float2 temp_output_1_0_g1 = v.texcoord.xy;
			float2 temp_output_11_0_g1 = ( temp_output_1_0_g1 - float2( 0.5,0.5 ) );
			float2 break18_g1 = temp_output_11_0_g1;
			float2 appendResult19_g1 = (float2(break18_g1.y , -break18_g1.x));
			float dotResult12_g1 = dot( temp_output_11_0_g1 , temp_output_11_0_g1 );
			float2 coords45 = ( temp_output_1_0_g1 + ( appendResult19_g1 * ( dotResult12_g1 * float2( 3,1 ) ) ) + float2( 0,0 ) ) * _Cell_Density;
			float2 id45 = 0;
			float voroi45 = voronoi45( coords45, time45,id45, 0 );
			float Voronoi91 = voroi45;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 Vertex_Offset105 = ( Voronoi91 * ( ase_vertexNormal * _OffsetValue ) );
			v.vertex.xyz += Vertex_Offset105;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float time45 = ( _Angle_Speed * _Time.y );
			float2 temp_output_1_0_g1 = i.uv_texcoord;
			float2 temp_output_11_0_g1 = ( temp_output_1_0_g1 - float2( 0.5,0.5 ) );
			float2 break18_g1 = temp_output_11_0_g1;
			float2 appendResult19_g1 = (float2(break18_g1.y , -break18_g1.x));
			float dotResult12_g1 = dot( temp_output_11_0_g1 , temp_output_11_0_g1 );
			float2 coords45 = ( temp_output_1_0_g1 + ( appendResult19_g1 * ( dotResult12_g1 * float2( 3,1 ) ) ) + float2( 0,0 ) ) * _Cell_Density;
			float2 id45 = 0;
			float voroi45 = voronoi45( coords45, time45,id45, 0 );
			float Voronoi91 = voroi45;
			float4 Ripple90 = ( _Albedo + ( ( ( 1.0 - step( Voronoi91 , _Step_Intensity ) ) + ( 0.1 * Voronoi91 ) ) * _Ripple_Color ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float eyeDepth69 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float smoothstepResult77 = smoothstep( _DistanceFade , ( _DistanceFade + _Smoothness ) , saturate( ( eyeDepth69 - i.eyeDepth ) ));
			float4 lerpResult78 = lerp( _Color_Global , Ripple90 , smoothstepResult77);
			float4 Emission103 = lerpResult78;
			o.Emission = Emission103.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
204;492;1188;439;1013.281;579.9943;1.252979;True;False
Node;AmplifyShaderEditor.CommentaryNode;108;-751.8546,-427.8746;Inherit;False;1192.903;650.3638;Test du node voronoi;8;46;48;57;49;50;56;45;91;Main_Ripple;0.3496351,0.6556882,0.764151,1;0;0
Node;AmplifyShaderEditor.Vector2Node;57;-585.3864,-377.8746;Inherit;False;Constant;_Vector3;Vector 3;6;0;Create;True;0;0;False;0;3,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;48;-701.8546,-194.3582;Inherit;False;Property;_Angle_Speed;Angle_Speed;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;-619.3723,-4.561651;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;56;-272.4786,-304.981;Inherit;False;Radial Shear;-1;;1;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-308.0359,107.4892;Inherit;False;Property;_Cell_Density;Cell_Density;5;0;Create;True;0;0;False;0;7;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-386.527,-74.68624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;45;-93.50269,-74.30955;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;2,5;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;198.0486,-81.88074;Inherit;False;Voronoi;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;728.6844,-814.0729;Inherit;False;1568.871;943.2221;J'ai step le voronoi pour avoir des vaguelettes plus sharp et coller à ma direction artistique;12;93;96;100;99;95;97;102;98;53;54;47;55;Step;0.2703364,0.4159046,0.764151,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;778.6844,-527.1625;Inherit;False;91;Voronoi;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;831.1602,-270.6371;Inherit;False;Property;_Step_Intensity;Step_Intensity;9;0;Create;True;0;0;False;0;0;0.28;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;1107.643,-100.8508;Inherit;False;91;Voronoi;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;1124.688,-322.5089;Inherit;False;Constant;_Opacity;Opacity;10;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;95;1014.689,-557.093;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;1304.731,-199.3954;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;97;1285.977,-545.5833;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;1570.301,-506.7209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;107;-864.0356,541.8433;Inherit;False;1310.629;784.9587;Foam principal pour ajouter du détail sur l'île;11;69;68;72;71;70;73;74;89;77;75;78;Foam;0.511748,0.7656316,0.8679245,1;0;0
Node;AmplifyShaderEditor.ColorNode;53;1633.608,-229.6028;Inherit;False;Property;_Ripple_Color;Ripple_Color;7;1;[HDR];Create;True;0;0;False;0;0.8156863,2.917647,3.623529,0;0.3261609,0.3348701,1.597352,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SurfaceDepthNode;68;-814.0356,906.813;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;1395.761,-764.0729;Inherit;False;Property;_Albedo;Albedo;1;1;[HDR];Create;True;0;0;False;0;0.3372549,0.6117647,1.592157,0;0.01806693,0.01806693,0.1320755,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;1890.21,-490.6187;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenDepthNode;69;-774.7307,788.898;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;110;951.775,1086.754;Inherit;False;1268.564;828.823;Léger verrtex_offset basé sur le voronoi pour rajouter de la vie à la foam;6;60;59;92;61;62;105;Vertex_Offset;0.4190103,0.8301887,0.821792,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-636.4081,1211.802;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-523.9921,837.0981;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-634.4191,1103.691;Inherit;False;Property;_DistanceFade;Distance Fade;4;0;Create;True;0;0;False;0;0;0.259;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;2062.555,-552.9191;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-258.347,1173.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;1192.195,1657.577;Float;False;Property;_OffsetValue;OffsetValue;8;0;Create;True;0;0;False;0;0.5;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;73;-359.8691,863.0991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;2355.329,-532.9659;Inherit;False;Ripple;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;59;980.6467,1290.158;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1253.246,1282.172;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-33.19537,730.5528;Inherit;False;90;Ripple;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;77;-105.114,1079.928;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-511.475,591.8433;Inherit;False;Property;_Color_Global;Color_Global;2;1;[HDR];Create;True;0;0;False;0;0,0.01166201,1,0;0.2134678,0.2498662,0.448071,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;92;1460.679,1136.754;Inherit;False;91;Voronoi;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;262.5935,947.9376;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;1758.664,1400.513;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;541.2871,948.0223;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;1976.339,1417.72;Inherit;False;Vertex_Offset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;1304.989,510.3701;Inherit;False;103;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;1265.562,712.6754;Inherit;False;105;Vertex_Offset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1600.657,429.5995;Float;False;True;-1;7;ASEMaterialInspector;0;0;Unlit;Water_Toon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;56;3;57;0
WireConnection;49;0;48;0
WireConnection;49;1;46;0
WireConnection;45;0;56;0
WireConnection;45;1;49;0
WireConnection;45;2;50;0
WireConnection;91;0;45;0
WireConnection;95;0;93;0
WireConnection;95;1;96;0
WireConnection;102;0;100;0
WireConnection;102;1;99;0
WireConnection;97;0;95;0
WireConnection;98;0;97;0
WireConnection;98;1;102;0
WireConnection;54;0;98;0
WireConnection;54;1;53;0
WireConnection;70;0;69;0
WireConnection;70;1;68;0
WireConnection;55;0;47;0
WireConnection;55;1;54;0
WireConnection;74;0;72;0
WireConnection;74;1;71;0
WireConnection;73;0;70;0
WireConnection;90;0;55;0
WireConnection;61;0;59;0
WireConnection;61;1;60;0
WireConnection;77;0;73;0
WireConnection;77;1;72;0
WireConnection;77;2;74;0
WireConnection;78;0;75;0
WireConnection;78;1;89;0
WireConnection;78;2;77;0
WireConnection;62;0;92;0
WireConnection;62;1;61;0
WireConnection;103;0;78;0
WireConnection;105;0;62;0
WireConnection;0;2;104;0
WireConnection;0;11;106;0
ASEEND*/
//CHKSM=8A31A3ECAAF8384F586B3D40D7DC54713E031551