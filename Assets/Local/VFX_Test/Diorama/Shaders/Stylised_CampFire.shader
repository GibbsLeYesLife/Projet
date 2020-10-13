// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Stylised_Campfire"
{
	Properties
	{
		_Noise_1("Noise_1", 2D) = "white" {}
		_Scale_Noise_1("Scale_Noise_1", Float) = 1
		_Speed_Noise_1("Speed_Noise_1", Float) = -1.5
		_Noise_2("Noise_2", 2D) = "white" {}
		_Scale_Noise_2("Scale_Noise_2", Float) = 0.5
		_Speed_Noise_2("Speed_Noise_2", Float) = -1
		_Noise_Intensity("Noise_Intensity", Float) = 1
		_Shape("Shape", 2D) = "white" {}
		_Intensity_Step_1("Intensity_Step_1", Range( 0 , 1)) = 0.155304
		_Intensity_Step_2("Intensity_Step_2", Range( 0 , 1)) = 0.09487711
		_Intensity_Step_3("Intensity_Step_3", Range( 0 , 1)) = 0.155304
		[HDR]_Color_1("Color_1", Color) = (1.584906,0.8370304,0.1719473,0)
		[HDR]_Color_2("Color_2", Color) = (1.698113,0.9392148,0.264329,0)
		[HDR]_Color_3("Color_3", Color) = (0,0,0,0)
		[HDR]_Top_Color("Top_Color", Color) = (0.3475208,0.7428775,1.701961,0)
		_Top_Color_Blend("Top_Color_Blend", Range( 0 , 1)) = 0.9778624
		_Final_Power("Final_Power", Float) = 1
		_Vertex_Offset("Vertex_Offset", Float) = 0
		_Burn_Intensity("Burn_Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		Blend One One , One One
		BlendOp Add
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Noise_Intensity;
		uniform sampler2D _Shape;
		uniform float4 _Shape_ST;
		uniform sampler2D _Noise_1;
		uniform float _Speed_Noise_1;
		uniform float _Scale_Noise_1;
		uniform sampler2D _Noise_2;
		uniform float _Speed_Noise_2;
		uniform float _Scale_Noise_2;
		uniform float _Vertex_Offset;
		uniform float _Final_Power;
		uniform float4 _Color_1;
		uniform float _Intensity_Step_1;
		uniform float _Intensity_Step_2;
		uniform float4 _Color_2;
		uniform float _Top_Color_Blend;
		uniform float4 _Top_Color;
		uniform float _Intensity_Step_3;
		uniform float4 _Color_3;
		uniform float _Burn_Intensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
			float2 uv_Shape = v.texcoord * _Shape_ST.xy + _Shape_ST.zw;
			float4 tex2DNode20 = tex2Dlod( _Shape, float4( uv_Shape, 0, 0.0) );
			float2 appendResult7 = (float2(0.0 , _Speed_Noise_1));
			float2 panner10 = ( 1.0 * _Time.y * appendResult7 + ( _Scale_Noise_1 * v.texcoord.xy ));
			float2 appendResult6 = (float2(0.0 , _Speed_Noise_2));
			float2 panner11 = ( 1.0 * _Time.y * appendResult6 + ( v.texcoord.xy * _Scale_Noise_2 ));
			float Shape30 = ( _Noise_Intensity * ( tex2DNode20.r * ( tex2DNode20.r + ( tex2Dlod( _Noise_1, float4( panner10, 0, 0.0) ).r * tex2Dlod( _Noise_2, float4( panner11, 0, 0.0) ).r ) ) ) );
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( Shape30 * ( ( 0 + ase_vertex3Pos ) * _Vertex_Offset ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Shape = i.uv_texcoord * _Shape_ST.xy + _Shape_ST.zw;
			float4 tex2DNode20 = tex2D( _Shape, uv_Shape );
			float2 appendResult7 = (float2(0.0 , _Speed_Noise_1));
			float2 panner10 = ( 1.0 * _Time.y * appendResult7 + ( _Scale_Noise_1 * i.uv_texcoord ));
			float2 appendResult6 = (float2(0.0 , _Speed_Noise_2));
			float2 panner11 = ( 1.0 * _Time.y * appendResult6 + ( i.uv_texcoord * _Scale_Noise_2 ));
			float Shape30 = ( _Noise_Intensity * ( tex2DNode20.r * ( tex2DNode20.r + ( tex2D( _Noise_1, panner10 ).r * tex2D( _Noise_2, panner11 ).r ) ) ) );
			float temp_output_32_0 = step( _Intensity_Step_1 , Shape30 );
			float smoothstepResult46 = smoothstep( 0.0 , _Top_Color_Blend , i.uv_texcoord.y);
			float4 temp_cast_0 = (_Burn_Intensity).xxxx;
			o.Emission = ( _Final_Power * pow( ( ( _Color_1 * temp_output_32_0 ) + ( ( step( _Intensity_Step_2 , Shape30 ) - temp_output_32_0 ) * ( ( _Color_2 * ( 1.0 - smoothstepResult46 ) ) + ( smoothstepResult46 * _Top_Color ) ) ) + ( step( _Intensity_Step_3 , Shape30 ) * _Color_3 ) ) , temp_cast_0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
204;492;1188;439;-641.1864;480.7271;3.417019;True;False
Node;AmplifyShaderEditor.CommentaryNode;74;-1567.647,-261.4215;Inherit;False;1653.996;900.3474;Multiply des noises à différentes speed/tiles pour avoir un effeut aléatoire et "brulant";16;1;5;4;3;2;8;7;9;6;11;13;10;55;14;12;15;Noise;0.7924528,0.1981132,0.1981132,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1517.647,54.69812;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1365.922,206.3533;Float;False;Property;_Scale_Noise_2;Scale_Noise_2;5;0;Create;True;0;0;False;0;0.5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1180.674,324.5577;Float;False;Property;_Speed_Noise_2;Speed_Noise_2;6;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1351.638,-75.49248;Float;False;Property;_Scale_Noise_1;Scale_Noise_1;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-1350.174,-172.1074;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;3;0;Create;True;0;0;False;0;-1.5;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-1088.526,-196.0219;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1084.788,-12.77446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-902.5735,250.7862;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1080.619,156.1592;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;75;150.6282,-227.4666;Inherit;False;1538.138;665.8923;Multiply le noise avec la shape que je veux pour lui donner la forme d'une flamme;7;18;20;19;17;21;16;30;Fire_Shape;0.8396226,0.5478953,0.360404,1;0;0
Node;AmplifyShaderEditor.PannerNode;10;-812.0464,-211.4216;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;11;-716.3879,177.4015;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;55;-586.4125,408.9257;Float;True;Property;_Noise_2;Noise_2;4;0;Create;True;0;0;False;0;None;503139e193fb16448a7dcfc08dc2d91e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-830.6332,-8.350844;Float;True;Property;_Noise_1;Noise_1;1;0;Create;True;0;0;False;0;7009da5090971f84cb0c36a27b682288;7009da5090971f84cb0c36a27b682288;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;14;-488.8459,75.1571;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-541.9594,-162.5518;Inherit;True;Property;_Tex;Tex;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;18;200.6281,-161.4565;Float;True;Property;_Shape;Shape;8;0;Create;True;0;0;False;0;9c2f856ea91d0ac4b94e933c5e6924d0;9c2f856ea91d0ac4b94e933c5e6924d0;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;20;531.2683,-76.68661;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-148.6508,-31.71101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;680.0893,185.4261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;851.2843,-177.4665;Float;False;Property;_Noise_Intensity;Noise_Intensity;7;0;Create;True;0;0;False;0;1;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;76;1527.94,1074.571;Inherit;False;1670.471;885.2088;Je gère les couleurs avec les différents step et avec un gradient qui me permet de gérer la couleur du haut en bas de la flamme;10;45;43;46;38;42;48;51;47;52;58;Color;0.1764706,0.2434243,0.8784314,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;940.9418,135.8763;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;1593.57,1244.206;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;1577.94,1510.082;Float;False;Property;_Top_Color_Blend;Top_Color_Blend;16;0;Create;True;0;0;False;0;0.9778624;0.874;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;1165.161,135.573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;1445.766,138.0973;Float;False;Shape;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;1822.689,-274.1235;Inherit;False;1157.988;998.8732;Je step ma shape plusieurs fois pour séparer les différentes parties de ma flamme;9;29;35;34;32;33;56;36;57;59;Steps;0.8396226,0.7845811,0.2178266,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;46;2078.775,1525.992;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;48;2398.91,1409.275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;1672.226,1752.78;Float;False;Property;_Top_Color;Top_Color;15;1;[HDR];Create;True;0;0;False;0;0.3475208,0.7428775,1.701961,0;0.1968521,0.3550965,1.814463,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;2088.839,1307.337;Float;False;Property;_Color_2;Color_2;13;1;[HDR];Create;True;0;0;False;0;1.698113,0.9392148,0.264329,0;3.30732,0.8357206,0.1422503,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;2005.086,-224.1235;Float;False;Property;_Intensity_Step_1;Intensity_Step_1;9;0;Create;True;0;0;False;0;0.155304;0.345;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;2000.969,214.2449;Float;False;Property;_Intensity_Step_2;Intensity_Step_2;10;0;Create;True;0;0;False;0;0.09487711;0.052;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;1952.308,6.885039;Inherit;False;30;Shape;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;2703.717,1425.934;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;1872.689,452.1563;Float;False;Property;_Intensity_Step_3;Intensity_Step_3;11;0;Create;True;0;0;False;0;0.155304;0.162;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;33;2343.029,151.1464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;32;2326.424,-119.5129;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;2391.076,1635.403;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;2625.385,151.1464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;2963.411,1575.455;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;58;2479.751,1124.571;Float;False;Property;_Color_3;Color_3;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.283019,0.1028836,0.1379081,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;37;3012.882,-334.1578;Float;False;Property;_Color_1;Color_1;12;1;[HDR];Create;True;0;0;False;0;1.584906,0.8370304,0.1719473,0;1.019608,0.01568628,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;78;3767.836,856.4429;Inherit;False;916.8862;933.2961;Je viens rajouter un léger vertex offset pour casser le mouvement trop linéaire;7;70;67;61;71;65;60;66;Vertex_Offset;0.512994,0.7809215,0.8301887,1;0;0
Node;AmplifyShaderEditor.StepOpNode;57;2412.529,459.0971;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;3101.093,299.9883;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BillboardNode;70;4205.18,1428.43;Inherit;False;Cylindrical;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;2745.677,471.7497;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;3115.463,-67.2615;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;67;3889.649,1564.739;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;3528.874,271.9043;Float;False;Property;_Burn_Intensity;Burn_Intensity;19;0;Create;True;0;0;False;0;0;2.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;3352.261,99.13935;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;4449.722,1452.287;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;61;3817.836,1082.866;Float;False;Property;_Vertex_Offset;Vertex_Offset;18;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;3828.135,-177.5167;Float;False;Property;_Final_Power;Final_Power;17;0;Create;True;0;0;False;0;1;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;4211.324,1123.428;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;68;3693.785,84.02908;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;3998.38,906.4429;Inherit;False;30;Shape;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;4446.187,983.5525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;4005.645,64.96503;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;73;4436.949,-7.063921;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Stylised_Campfire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;1;1;0
WireConnection;8;0;2;0
WireConnection;8;1;5;0
WireConnection;6;1;3;0
WireConnection;9;0;5;0
WireConnection;9;1;4;0
WireConnection;10;0;8;0
WireConnection;10;2;7;0
WireConnection;11;0;9;0
WireConnection;11;2;6;0
WireConnection;14;0;55;0
WireConnection;14;1;11;0
WireConnection;12;0;13;0
WireConnection;12;1;10;0
WireConnection;20;0;18;0
WireConnection;15;0;12;1
WireConnection;15;1;14;1
WireConnection;19;0;20;1
WireConnection;19;1;15;0
WireConnection;21;0;20;1
WireConnection;21;1;19;0
WireConnection;16;0;17;0
WireConnection;16;1;21;0
WireConnection;30;0;16;0
WireConnection;46;0;45;2
WireConnection;46;2;43;0
WireConnection;48;0;46;0
WireConnection;51;0;38;0
WireConnection;51;1;48;0
WireConnection;33;0;35;0
WireConnection;33;1;29;0
WireConnection;32;0;34;0
WireConnection;32;1;29;0
WireConnection;47;0;46;0
WireConnection;47;1;42;0
WireConnection;36;0;33;0
WireConnection;36;1;32;0
WireConnection;52;0;51;0
WireConnection;52;1;47;0
WireConnection;57;0;56;0
WireConnection;57;1;29;0
WireConnection;40;0;36;0
WireConnection;40;1;52;0
WireConnection;59;0;57;0
WireConnection;59;1;58;0
WireConnection;39;0;37;0
WireConnection;39;1;32;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;41;2;59;0
WireConnection;71;0;70;0
WireConnection;71;1;67;0
WireConnection;65;0;71;0
WireConnection;65;1;61;0
WireConnection;68;0;41;0
WireConnection;68;1;69;0
WireConnection;66;0;60;0
WireConnection;66;1;65;0
WireConnection;53;0;54;0
WireConnection;53;1;68;0
WireConnection;73;2;53;0
WireConnection;73;11;66;0
ASEEND*/
//CHKSM=437F8DE49D5B4B3DDF7174F3CD4EA9097A4F782A