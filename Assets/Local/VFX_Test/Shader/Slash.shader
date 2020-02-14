// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Slash"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TexturePrincipale("TexturePrincipale", 2D) = "white" {}
		_Tiling_Noise_Secondary("Tiling_Noise_Secondary", Vector) = (0,0,0,0)
		_Emissive("Emissive", Float) = 0
		_Tiling_Noise_1("Tiling_Noise_1", Vector) = (1,1,0,0)
		_Speed_Noise_1("Speed_Noise_1", Vector) = (3,1,0,0)
		_Speed_Noise_Secondary("Speed_Noise_Secondary", Vector) = (0,0,0,0)
		_T_Lu_Noise_01("T_Lu_Noise_01", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
	}

	Category 
	{
		SubShader
		{
			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					float4 ase_texcoord1 : TEXCOORD1;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_OUTPUT_STEREO
					float4 ase_texcoord3 : TEXCOORD3;
				};
				
				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform sampler2D_float _CameraDepthTexture;
				uniform float _InvFade;
				uniform float _Emissive;
				uniform sampler2D _TexturePrincipale;
				uniform sampler2D _T_Lu_Noise_01;
				uniform float2 _Tiling_Noise_1;
				uniform float2 _Speed_Noise_1;
				uniform sampler2D _TextureSample0;
				uniform float2 _Tiling_Noise_Secondary;
				uniform float2 _Speed_Noise_Secondary;

				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					o.ase_texcoord3.xyz = v.ase_texcoord1.xyz;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord3.w = 0;

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float4 color77 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
					float3 uv4 = i.ase_texcoord3.xyz;
					uv4.xy = i.ase_texcoord3.xyz.xy * float2( 1,1 ) + float2( 0,0 );
					float4 temp_cast_0 = (uv4.z).xxxx;
					float4 temp_cast_1 = (( uv4.z + 0.0 )).xxxx;
					float temp_output_11_0 = (2.5 + (( 1.0 + uv4.x ) - 0.0) * (1.0 - 2.5) / (1.0 - 0.0));
					float2 uv7 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float U8 = uv7.x;
					float temp_output_10_0 = (1.0 + (saturate( uv4.y ) - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
					float V9 = uv7.y;
					float2 appendResult19 = (float2(( saturate( ( ( ( temp_output_11_0 * temp_output_11_0 * temp_output_11_0 * temp_output_11_0 * temp_output_11_0 ) * U8 ) - temp_output_10_0 ) ) * ( 1.0 / (1.0 + (temp_output_10_0 - 0.0) * (0.001 - 1.0) / (1.0 - 0.0)) ) ) , V9));
					float2 panner102 = ( 1.0 * _Time.y * _Speed_Noise_1 + float2( 0,0 ));
					float2 uv103 = i.texcoord.xy * _Tiling_Noise_1 + panner102;
					float2 panner100 = ( 1.0 * _Time.y * _Speed_Noise_Secondary + float2( 0,0 ));
					float2 uv104 = i.texcoord.xy * _Tiling_Noise_Secondary + panner100;
					float4 temp_output_107_0 = ( tex2D( _T_Lu_Noise_01, uv103 ) + tex2D( _TextureSample0, uv104 ) );
					float4 smoothstepResult22 = smoothstep( temp_cast_0 , temp_cast_1 , ( tex2D( _TexturePrincipale, saturate( appendResult19 ) ) * pow( temp_output_107_0 , 3.0 ) ));
					float4 temp_output_24_0 = saturate( smoothstepResult22 );
					float4 appendResult84 = (float4((( color77 * 1.0 * _Emissive * i.color )).rgb , ( color77.a * (temp_output_24_0).r * i.color.a )));
					

					fixed4 col = appendResult84;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16100
573;484;1077;463;1386.078;497.1859;4.458501;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1407.719,26.1407;Float;False;1;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1106.506,-167.3007;Float;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-865.8249,211.1651;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;11;-867.8101,-280.683;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-587.7457,-257.4824;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-572.3654,154.9566;Float;False;U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;-934.3538,10.36183;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;-618.0688,-71.18647;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-382.6572,-255.8252;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;98;-340.8233,1188.697;Float;False;Property;_Speed_Noise_Secondary;Speed_Noise_Secondary;5;0;Create;True;0;0;False;0;0,0;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-191.6783,-249.1964;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;15;-262.4814,-21.8811;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;97;-279.8333,717.0381;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;4;0;Create;True;0;0;False;0;3,1;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;99;-63.39111,919.0131;Float;False;Property;_Tiling_Noise_Secondary;Tiling_Noise_Secondary;1;0;Create;True;0;0;False;0;0,0;1,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;101;40.71488,365.4917;Float;False;Property;_Tiling_Noise_1;Tiling_Noise_1;3;0;Create;True;0;0;False;0;1,1;1,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;30.64594,-1.773291;Float;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;17.34854,-235.9389;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;100;-108.0992,1208.855;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;102;-43.34715,662.8251;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;186.6157,-172.6849;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-560.4139,340.2139;Float;False;V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;299.4577,474.0036;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;236.0057,1020.035;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;19;381.8837,-124.4219;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;106;505.0765,1042.812;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;6ca5b2e608f86e14d88db87d75ba2f41;15d3bdd335d3eb64986a7e3c3c9c8ea6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;105;688.9592,384.5448;Float;True;Property;_T_Lu_Noise_01;T_Lu_Noise_01;6;0;Create;True;0;0;False;0;6ca5b2e608f86e14d88db87d75ba2f41;14776e1fcbc9b804fb8873fb4173c30c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;107;1236.786,951.7401;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;20;540.1331,-189.7548;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;109;1597.715,641.9958;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;23;800.1304,-320.2925;Float;True;Property;_TexturePrincipale;TexturePrincipale;0;0;Create;True;0;0;False;0;None;a6d0a294cb123064ca181d7d3a6efa07;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;21;285.7507,169.0379;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;974.9271,167.3564;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;1174.227,-36.1019;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;1425.224,-237.9465;Float;False;Constant;_Z;Z;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;1413.141,-54.76402;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;80;1758.142,213.425;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;77;1610.131,-523.2469;Float;False;Constant;_MainColor;MainColor;1;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchNode;75;1676.704,-265.221;Float;False;0;2;8;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;1794.871,-113.522;Float;False;Property;_Emissive;Emissive;2;0;Create;True;0;0;False;0;0;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;2103.626,-222.1083;Float;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;79;1652.537,24.01219;Float;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;85;2315.572,-221.0616;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;2190.807,78.48759;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;108;1457.651,1216.322;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;2565.348,-215.1216;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;96;2997.082,-209.7991;Float;False;True;2;Float;ASEMaterialInspector;0;6;Slash;0b6a9f8b4f707c74ca64c0be8e590de0;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;True;2;False;-1;True;True;True;True;False;0;False;-1;False;True;2;False;-1;True;3;False;-1;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;True;0;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;5;1;4;1
WireConnection;11;0;5;0
WireConnection;12;0;11;0
WireConnection;12;1;11;0
WireConnection;12;2;11;0
WireConnection;12;3;11;0
WireConnection;12;4;11;0
WireConnection;8;0;7;1
WireConnection;6;0;4;2
WireConnection;10;0;6;0
WireConnection;13;0;12;0
WireConnection;13;1;8;0
WireConnection;14;0;13;0
WireConnection;14;1;10;0
WireConnection;15;0;10;0
WireConnection;16;1;15;0
WireConnection;17;0;14;0
WireConnection;100;2;98;0
WireConnection;102;2;97;0
WireConnection;18;0;17;0
WireConnection;18;1;16;0
WireConnection;9;0;7;2
WireConnection;103;0;101;0
WireConnection;103;1;102;0
WireConnection;104;0;99;0
WireConnection;104;1;100;0
WireConnection;19;0;18;0
WireConnection;19;1;9;0
WireConnection;106;1;104;0
WireConnection;105;1;103;0
WireConnection;107;0;105;0
WireConnection;107;1;106;0
WireConnection;20;0;19;0
WireConnection;109;0;107;0
WireConnection;23;1;20;0
WireConnection;21;0;4;3
WireConnection;110;0;23;0
WireConnection;110;1;109;0
WireConnection;22;0;110;0
WireConnection;22;1;4;3
WireConnection;22;2;21;0
WireConnection;24;0;22;0
WireConnection;75;0;76;0
WireConnection;75;1;24;0
WireConnection;81;0;77;0
WireConnection;81;1;75;0
WireConnection;81;2;82;0
WireConnection;81;3;80;0
WireConnection;79;0;24;0
WireConnection;85;0;81;0
WireConnection;78;0;77;4
WireConnection;78;1;79;0
WireConnection;78;2;80;4
WireConnection;108;0;107;0
WireConnection;84;0;85;0
WireConnection;84;3;78;0
WireConnection;96;0;84;0
ASEEND*/
//CHKSM=F3E7DFB95C9081DF80028DCE65E49CEBF30176B9