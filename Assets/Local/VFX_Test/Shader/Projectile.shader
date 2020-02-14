// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Arc_Shot"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Dissolve("Dissolve", Range( -20 , 20)) = 6.084421
		_Range("Range", Range( -20 , 20)) = 16.48606
		_Vector0("Vector 0", Vector) = (1,1,0,0)
		_Tiling("Tiling", Vector) = (1,1,0,0)
		[HDR]_GlowColor("Glow Color", Color) = (0,1.582753,3.435294,0)
		[HDR]_Color0("Color 0", Color) = (0,1.582753,3.435294,0)
		_Float1("Float 1", Float) = 2
		_Float0("Float 0", Float) = 2
		_OffsetValue("OffsetValue", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float2 _Vector0;
		uniform float _Float1;
		uniform float2 _Tiling;
		uniform float _Float0;
		uniform float _Dissolve;
		uniform float _Range;
		uniform float _OffsetValue;
		uniform float4 _GlowColor;
		uniform float4 _Color0;
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
			float mulTime110 = _Time.y * _Float1;
			float2 panner112 = ( mulTime110 * float2( 1,-10 ) + float2( 0,0 ));
			float2 uv_TexCoord113 = v.texcoord.xy * _Vector0 + panner112;
			float simplePerlin2D114 = snoise( uv_TexCoord113 );
			float mulTime82 = _Time.y * _Float0;
			float2 panner83 = ( mulTime82 * float2( 2,-5 ) + float2( 0,0 ));
			float2 uv_TexCoord85 = v.texcoord.xy * _Tiling + panner83;
			float simplePerlin2D87 = snoise( uv_TexCoord85 );
			float Noise21 = ( ( simplePerlin2D114 + simplePerlin2D87 ) + 0.94 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float2 uv_TexCoord122 = v.texcoord.xy + float2( 0,-0.25 );
			float Y_Gradient23 = saturate( ( ( ( transform41.w + saturate( -(0.001 + (sin( ( uv_TexCoord122.y * 6.5 ) ) - 1.0) * (10.0 - 0.001) / (8.0 - 1.0)) ) ) + _Dissolve ) / _Range ) );
			float3 VertexOffset56 = ( Noise21 * ( ( ase_vertex3Pos * Y_Gradient23 ) * _OffsetValue ) );
			v.vertex.xyz += VertexOffset56;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime110 = _Time.y * _Float1;
			float2 panner112 = ( mulTime110 * float2( 1,-10 ) + float2( 0,0 ));
			float2 uv_TexCoord113 = i.uv_texcoord * _Vector0 + panner112;
			float simplePerlin2D114 = snoise( uv_TexCoord113 );
			float mulTime82 = _Time.y * _Float0;
			float2 panner83 = ( mulTime82 * float2( 2,-5 ) + float2( 0,0 ));
			float2 uv_TexCoord85 = i.uv_texcoord * _Tiling + panner83;
			float simplePerlin2D87 = snoise( uv_TexCoord85 );
			float Noise21 = ( ( simplePerlin2D114 + simplePerlin2D87 ) + 0.94 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float2 uv_TexCoord122 = i.uv_texcoord + float2( 0,-0.25 );
			float Y_Gradient23 = saturate( ( ( ( transform41.w + saturate( -(0.001 + (sin( ( uv_TexCoord122.y * 6.5 ) ) - 1.0) * (10.0 - 0.001) / (8.0 - 1.0)) ) ) + _Dissolve ) / _Range ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV125 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode125 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV125, 10.0 ) );
			float4 Emission36 = ( ( ( Noise21 * Y_Gradient23 ) * _GlowColor ) + ( fresnelNode125 * _Color0 ) );
			o.Emission = Emission36.rgb;
			o.Alpha = 1;
			float temp_output_30_0 = ( Y_Gradient23 * 0.52 );
			float Opacity_mask26 = ( ( ( Noise21 * ( 1.0 - Y_Gradient23 ) ) - temp_output_30_0 ) + ( 1.0 - temp_output_30_0 ) );
			clip( Opacity_mask26 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1068;100;692;822;298.4064;136.3083;1.640781;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-3098.752,950.2157;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,-0.25;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;120;-2878.51,1004.288;Float;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-2589.804,1250.58;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;6.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;121;-2328.343,1262.426;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;116;-2456.192,921.9626;Float;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;8;False;3;FLOAT;0.001;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-2314.63,-1126.883;Float;False;Property;_Float1;Float 1;7;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-2261.041,-431.8391;Float;False;Property;_Float0;Float 0;8;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;117;-2124.232,889.7552;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-3123.395,-116.3041;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;110;-2128.791,-1200.24;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;82;-2075.201,-505.1963;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;118;-2600.572,612.6017;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;41;-2702.726,-115.4726;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;83;-1905.665,-637.5685;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,-5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;112;-1959.256,-1333.911;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,-10;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;111;-1977.216,-1658.312;Float;False;Property;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;1,1;15,15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;84;-1923.625,-963.2701;Float;False;Property;_Tiling;Tiling;4;0;Create;True;0;0;False;0;1,1;15,15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;13;-2732.262,293.6994;Float;False;Property;_Dissolve;Dissolve;1;0;Create;True;0;0;False;0;6.084421;14.8;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2366.424,-9.817807;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-1664.882,-854.756;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;113;-1718.474,-1549.797;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-2071.634,411.841;Float;False;Property;_Range;Range;2;0;Create;True;0;0;False;0;16.48606;20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-2133.883,60.97847;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;87;-1327.76,-1019.46;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;114;-1329.046,-1292.69;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1903.375,54.04087;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1609.819,-495.6364;Float;False;Constant;_Booster;Booster;2;0;Create;True;0;0;False;0;0.94;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-1053.789,-1142.252;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-1653.869,123.1283;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1377.343,-536.0164;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1466.919,235.5385;Float;False;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-979.535,-503.3774;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1563.862,1246.796;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;53;-832.8642,-109.0265;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;22;-424.3138,-795.6616;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-406.4628,-499.3878;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-815.842,170.741;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1226.508,1247.256;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1571.005,1571.615;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-1220.657,804.3195;Float;True;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;125;269.3268,-391.3136;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-577.588,-122.3342;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-70.52596,-709.1789;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-582.2939,300.5201;Float;False;Property;_OffsetValue;OffsetValue;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1025.491,1000.391;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1109.505,1553.74;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;129;255.382,-178.383;Float;False;Property;_Color0;Color 0;6;1;[HDR];Create;True;0;0;False;0;0,1.582753,3.435294,0;3.435294,2.767896,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;284.5471,-943.3813;Float;False;Property;_GlowColor;Glow Color;5;1;[HDR];Create;True;0;0;False;0;0,1.582753,3.435294,0;0,1.582753,3.435294,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;547.4164,-165.2495;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-823.8708,1293.849;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;286.8601,-679.7297;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;32;-817.0226,1555.781;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-299.571,63.29256;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-138.7116,-248.6777;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;645.7272,-396.3103;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-49.34518,73.0416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-569.5867,1559.037;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-435.2203,1259.553;Float;False;Opacity_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;223.0208,24.79716;Float;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;548.1976,-698.2295;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;178.4716,1169.207;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;72.17012,822.6006;Float;False;26;Opacity_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;55.20156,312.1006;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Arc_Shot;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;120;0;122;2
WireConnection;119;0;120;0
WireConnection;121;0;119;0
WireConnection;116;0;121;0
WireConnection;117;0;116;0
WireConnection;110;0;109;0
WireConnection;82;0;81;0
WireConnection;118;0;117;0
WireConnection;41;0;11;0
WireConnection;83;1;82;0
WireConnection;112;1;110;0
WireConnection;12;0;41;4
WireConnection;12;1;118;0
WireConnection;85;0;84;0
WireConnection;85;1;83;0
WireConnection;113;0;111;0
WireConnection;113;1;112;0
WireConnection;123;0;12;0
WireConnection;123;1;13;0
WireConnection;87;0;85;0
WireConnection;114;0;113;0
WireConnection;14;0;123;0
WireConnection;14;1;15;0
WireConnection;115;0;114;0
WireConnection;115;1;87;0
WireConnection;16;0;14;0
WireConnection;90;0;115;0
WireConnection;90;1;89;0
WireConnection;23;0;16;0
WireConnection;21;0;90;0
WireConnection;17;0;24;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;35;0;22;0
WireConnection;35;1;34;0
WireConnection;18;0;25;0
WireConnection;18;1;17;0
WireConnection;30;0;29;0
WireConnection;131;0;125;0
WireConnection;131;1;129;0
WireConnection;31;0;18;0
WireConnection;31;1;30;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;32;0;30;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;126;0;39;0
WireConnection;126;1;131;0
WireConnection;60;0;61;0
WireConnection;60;1;58;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;26;0;33;0
WireConnection;56;0;60;0
WireConnection;36;0;126;0
WireConnection;0;2;28;0
WireConnection;0;10;27;0
WireConnection;0;11;57;0
ASEEND*/
//CHKSM=DD117A7A6670CB23B3F90BAD6FAEF070115AD534