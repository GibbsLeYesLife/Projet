// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Warren_Back_Time"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Dissolve("Dissolve", Range( -20 , 20)) = 6.084421
		_Range("Range", Range( -20 , 20)) = 16.48606
		_Tiling("Tiling", Vector) = (1,1,0,0)
		[HDR]_GlowColor("Glow Color", Color) = (0,1.582753,3.435294,0)
		_Float0("Float 0", Float) = 2
		_OffsetValue("OffsetValue", Float) = 0
		_BT_Warren_TXT_Albedo("BT_Warren_TXT_Albedo", 2D) = "white" {}
		_BT_Warren_TXT_Normal("BT_Warren_TXT_Normal", 2D) = "bump" {}
		_BT_Warren_TXT_Metallic_Glossiness("BT_Warren_TXT_Metallic_Glossiness", 2D) = "white" {}
		_BT_Warren_TXT_Ao("BT_Warren_TXT_Ao", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float2 _Tiling;
		uniform float _Float0;
		uniform float _Dissolve;
		uniform float _Range;
		uniform float _OffsetValue;
		uniform sampler2D _BT_Warren_TXT_Normal;
		uniform float4 _BT_Warren_TXT_Normal_ST;
		uniform sampler2D _BT_Warren_TXT_Albedo;
		uniform float4 _BT_Warren_TXT_Albedo_ST;
		uniform float4 _GlowColor;
		uniform sampler2D _BT_Warren_TXT_Metallic_Glossiness;
		uniform float4 _BT_Warren_TXT_Metallic_Glossiness_ST;
		uniform sampler2D _BT_Warren_TXT_Ao;
		uniform float4 _BT_Warren_TXT_Ao_ST;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime82 = _Time.y * _Float0;
			float2 panner83 = ( mulTime82 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord85 = v.texcoord.xy * _Tiling + panner83;
			float simplePerlin2D87 = snoise( uv_TexCoord85 );
			float Noise21 = ( simplePerlin2D87 + 0.94 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float3 VertexOffset56 = ( Noise21 * ( ( ase_vertex3Pos * Y_Gradient23 ) * _OffsetValue ) );
			v.vertex.xyz += VertexOffset56;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BT_Warren_TXT_Normal = i.uv_texcoord * _BT_Warren_TXT_Normal_ST.xy + _BT_Warren_TXT_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _BT_Warren_TXT_Normal, uv_BT_Warren_TXT_Normal ) );
			float2 uv_BT_Warren_TXT_Albedo = i.uv_texcoord * _BT_Warren_TXT_Albedo_ST.xy + _BT_Warren_TXT_Albedo_ST.zw;
			o.Albedo = tex2D( _BT_Warren_TXT_Albedo, uv_BT_Warren_TXT_Albedo ).rgb;
			float mulTime82 = _Time.y * _Float0;
			float2 panner83 = ( mulTime82 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord85 = i.uv_texcoord * _Tiling + panner83;
			float simplePerlin2D87 = snoise( uv_TexCoord85 );
			float Noise21 = ( simplePerlin2D87 + 0.94 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float4 Emission36 = ( ( Noise21 * Y_Gradient23 ) * _GlowColor );
			o.Emission = Emission36.rgb;
			float2 uv_BT_Warren_TXT_Metallic_Glossiness = i.uv_texcoord * _BT_Warren_TXT_Metallic_Glossiness_ST.xy + _BT_Warren_TXT_Metallic_Glossiness_ST.zw;
			float4 tex2DNode72 = tex2D( _BT_Warren_TXT_Metallic_Glossiness, uv_BT_Warren_TXT_Metallic_Glossiness );
			o.Metallic = tex2DNode72.r;
			o.Smoothness = tex2DNode72.r;
			float2 uv_BT_Warren_TXT_Ao = i.uv_texcoord * _BT_Warren_TXT_Ao_ST.xy + _BT_Warren_TXT_Ao_ST.zw;
			o.Occlusion = tex2D( _BT_Warren_TXT_Ao, uv_BT_Warren_TXT_Ao ).r;
			o.Alpha = 1;
			float temp_output_30_0 = ( Y_Gradient23 * 0.52 );
			float Opacity_mask26 = ( ( ( Noise21 * ( 1.0 - Y_Gradient23 ) ) - temp_output_30_0 ) + ( 1.0 - temp_output_30_0 ) );
			clip( Opacity_mask26 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
681;350;617;838;1342.144;2394.793;2.604598;False;False
Node;AmplifyShaderEditor.RangedFloatNode;81;-2456.277,-1624.182;Float;False;Property;_Float0;Float 0;7;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-2825.5,-52.46973;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;82;-2270.438,-1697.539;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;41;-2498.809,-87.10179;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2732.262,293.6994;Float;False;Property;_Dissolve;Dissolve;1;0;Create;True;0;0;False;0;6.084421;1.5;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;84;-2118.862,-2155.612;Float;False;Property;_Tiling;Tiling;4;0;Create;True;0;0;False;0;1,1;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;83;-2100.902,-1831.211;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2071.634,411.841;Float;False;Property;_Range;Range;2;0;Create;True;0;0;False;0;16.48606;20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2187.021,71.97256;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-1860.12,-2047.098;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1903.375,54.04087;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1805.057,-1687.979;Float;False;Constant;_Booster;Booster;2;0;Create;True;0;0;False;0;0.94;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-1653.869,123.1283;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;87;-1559.398,-2071.396;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1572.581,-1728.359;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1466.919,235.5385;Float;False;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1563.862,1246.796;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-804.0057,-987.8953;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;53;-832.8642,-109.0265;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1571.005,1571.615;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1226.508,1247.256;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-815.842,170.741;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-1220.657,804.3195;Float;True;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-406.4628,-499.3878;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-577.588,-122.3342;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1025.491,1000.391;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-582.2939,300.5201;Float;False;Property;_OffsetValue;OffsetValue;8;0;Create;True;0;0;False;0;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1109.505,1553.74;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-424.3138,-795.6616;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-138.7116,-248.6777;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-823.8708,1293.849;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-299.571,63.29256;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;38;284.5471,-943.3813;Float;False;Property;_GlowColor;Glow Color;6;1;[HDR];Create;True;0;0;False;0;0,1.582753,3.435294,0;0,1.582753,3.435294,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;32;-817.0226,1555.781;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-70.52596,-709.1789;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;286.8601,-679.7297;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-569.5867,1559.037;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-49.34518,73.0416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;223.0208,24.79716;Float;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-435.2203,1259.553;Float;False;Opacity_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;548.1976,-698.2295;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;72;-249.8272,922.3758;Float;True;Property;_BT_Warren_TXT_Metallic_Glossiness;BT_Warren_TXT_Metallic_Glossiness;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;64;-1139.608,-996.0462;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;100;-1228.072,-2021.573;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-1413.912,-1948.216;Float;False;Property;_Float1;Float 1;5;0;Create;True;0;0;False;0;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;95;-2318.617,845.9307;Float;False;5;0;FLOAT;0;False;1;FLOAT;0.88;False;2;FLOAT;2.05;False;3;FLOAT;0.13;False;4;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;96;-1986.657,813.7233;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;97;-1794.503,685.5164;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-2421.829,1168.148;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;70;-259.1725,403.0449;Float;True;Property;_BT_Warren_TXT_Albedo;BT_Warren_TXT_Albedo;11;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-242.5491,-1809.724;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-770.1508,-2012.013;Float;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;0.56;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-530.2161,-2052.394;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;105;-517.033,-2395.433;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;102;-1058.536,-2155.247;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;101;-1076.496,-2479.648;Float;False;Property;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;1,1;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;104;-587.892,-1759.061;Float;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;False;0;b51a20d4daf88cb47a4761d87a406244;b51a20d4daf88cb47a4761d87a406244;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-817.7546,-2371.135;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;98;-1273.304,-1804.704;Float;True;Property;_Noise_Quadrillage;Noise_Quadrillage;17;0;Create;True;0;0;False;0;cee328edeca9c07438472db2b156f08e;cee328edeca9c07438472db2b156f08e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;28;55.20156,312.1006;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;92;-2609.733,849.8568;Float;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1438.647,-662.2794;Float;False;Property;_Thickness;Thickness;9;0;Create;True;0;0;False;0;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-2223.866,-1009.551;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-2281.744,-625.6221;Float;False;Constant;_Speed;Speed;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1963.414,-1003.764;Float;False;Property;_Noise_Scale;Noise_Scale;10;0;Create;True;0;0;False;0;5;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;94;-2190.768,1186.394;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;69;-1805.213,-720.1571;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1721.059,-1015.215;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;71;-339.2756,716.7797;Float;True;Property;_BT_Warren_TXT_Normal;BT_Warren_TXT_Normal;14;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-2961.177,874.1838;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,-0.25;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;27;72.17012,822.6006;Float;False;26;Opacity_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;178.4716,1169.207;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;86;-1650.769,-1455.539;Float;True;Property;_Tiling_Noise;Tiling_Noise;12;0;Create;True;0;0;False;0;b51a20d4daf88cb47a4761d87a406244;b51a20d4daf88cb47a4761d87a406244;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1102.101,-1509.97;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;73;9.170323,583.2759;Float;True;Property;_BT_Warren_TXT_Ao;BT_Warren_TXT_Ao;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2059.876,-741.3795;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;62;-1417.425,-1013.41;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Warren_Back_Time;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;82;0;81;0
WireConnection;41;0;11;0
WireConnection;83;1;82;0
WireConnection;12;0;41;2
WireConnection;12;1;13;0
WireConnection;85;0;84;0
WireConnection;85;1;83;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;16;0;14;0
WireConnection;87;0;85;0
WireConnection;90;0;87;0
WireConnection;90;1;89;0
WireConnection;23;0;16;0
WireConnection;21;0;90;0
WireConnection;17;0;24;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;18;0;25;0
WireConnection;18;1;17;0
WireConnection;30;0;29;0
WireConnection;31;0;18;0
WireConnection;31;1;30;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;32;0;30;0
WireConnection;35;0;22;0
WireConnection;35;1;34;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;60;0;61;0
WireConnection;60;1;58;0
WireConnection;56;0;60;0
WireConnection;26;0;33;0
WireConnection;36;0;39;0
WireConnection;64;0;62;0
WireConnection;64;1;65;0
WireConnection;100;0;99;0
WireConnection;95;0;94;0
WireConnection;96;0;95;0
WireConnection;97;0;96;0
WireConnection;93;0;92;0
WireConnection;107;0;105;0
WireConnection;107;1;104;0
WireConnection;108;0;106;0
WireConnection;108;1;107;0
WireConnection;105;0;103;0
WireConnection;102;1;100;0
WireConnection;104;1;103;0
WireConnection;103;0;101;0
WireConnection;103;1;102;0
WireConnection;98;1;85;0
WireConnection;92;0;91;2
WireConnection;94;0;93;0
WireConnection;69;1;68;0
WireConnection;2;0;63;0
WireConnection;2;1;69;0
WireConnection;86;1;85;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;62;0;2;2
WireConnection;0;0;70;0
WireConnection;0;1;71;0
WireConnection;0;2;28;0
WireConnection;0;3;72;0
WireConnection;0;4;72;0
WireConnection;0;5;73;0
WireConnection;0;10;27;0
WireConnection;0;11;57;0
ASEEND*/
//CHKSM=2885B08F511013A7FDB59270D7D9A6E9A9D29356