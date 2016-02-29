/*
   Scale4x shader 

           - Copyright (C) 2007 guest(r) - guest.r@gmail.com

           - License: GNU-GPL  


   The Scale2x, Scale4x algorithm:

           - Scale2x Homepage: http://scale2x.sourceforge.net/

           - Copyright (C) 2001, 2002, 2003, 2004 Andrea Mazzoleni 
		
           - License: GNU-GPL

*/



#include "shader.code"


string name : NAME = "Scale4x";
string preprocessTechique : PREPROCESSTECHNIQUE = "Scale2x_Pass1";
string combineTechique : COMBINETECHNIQUE =  "Scale2x_Pass2";

// **VS**

VERTEX_STUFF_W S_VERTEX0 (float3 p : POSITION, float2 tc : TEXCOORD0)
{
  VERTEX_STUFF_W OUT = (VERTEX_STUFF_W)0;

  OUT.coord = mul(float4(p,1),WorldViewProjection);
  OUT.CT = tc;
  return OUT;
}


// **PS**

float4 S_FRAGMENT0 ( in VERTEX_STUFF_W VAR ) : COLOR
{
	// calculating offsets, coordinates

	float2 dx = float2(2*ps.x, 0.0); 
	float2 dy = float2( 0.0,2*ps.y);
	
	float2 pixcoord  = 0.5*VAR.CT/ps;
	float2 fp        = frac(pixcoord);
	float2 d11       = VAR.CT-fp*ps;


	// Reading the texels

	float3 B = tex2D(s_p,d11-dy).xyz;
	float3 D = tex2D(s_p,d11-dx).xyz;
	float3 E = tex2D(s_p,d11   ).xyz;
	float3 F = tex2D(s_p,d11+dx).xyz;
	float3 H = tex2D(s_p,d11+dy).xyz;
	
	
	// The Scale2x algorithm

	float3 E0 = D == B && B != H && D != F ? D : E;
	float3 E1 = B == F && B != H && D != F ? F : E;
	float3 E2 = D == H && B != H && D != F ? D : E;
	float3 E3 = H == F && B != H && D != F ? F : E;


	// Product distribution

	fp = 1-step(fp,0.5);

	return float4((E3*fp.x+E2*(1-fp.x))*fp.y+(E1*fp.x+E0*(1-fp.x))*(1-fp.y),1); 
}

// **VS**

VERTEX_STUFF_W S_VERTEX (float3 p : POSITION, float2 tc : TEXCOORD0)
{
  VERTEX_STUFF_W OUT = (VERTEX_STUFF_W)0;

  OUT.coord = mul(float4(p,1),WorldViewProjection);
  OUT.CT = tc;
  return OUT;
}


// **PS**

float4 S_FRAGMENT ( in VERTEX_STUFF_W VAR ) : COLOR
{
	// calculating offsets, coordinates

	float2 dx = float2(ps.x, 0.0); 
	float2 dy = float2( 0.0,ps.y);
	
	float2 pixcoord  = VAR.CT/ps;
	float2 fp        = frac(pixcoord);
	float2 d11       = VAR.CT-fp*ps;


	// Reading the texels

	float3 B = tex2D(s_w,d11-dy).xyz;
	float3 D = tex2D(s_w,d11-dx).xyz;
	float3 E = tex2D(s_w,d11   ).xyz;
	float3 F = tex2D(s_w,d11+dx).xyz;
	float3 H = tex2D(s_w,d11+dy).xyz;
	
	
	// The Scale2x algorithm

	float3 E0 = D == B && B != H && D != F ? D : E;
	float3 E1 = B == F && B != H && D != F ? F : E;
	float3 E2 = D == H && B != H && D != F ? D : E;
	float3 E3 = H == F && B != H && D != F ? F : E;


	// Product distribution

	fp = 1-step(fp,0.5);
	return float4((E3*fp.x+E2*(1-fp.x))*fp.y+(E1*fp.x+E0*(1-fp.x))*(1-fp.y),1); 
}



technique Scale2x_Pass1
{
   pass P0
   {
     VertexShader = compile vs_2_0 S_VERTEX0();
     PixelShader  = compile ps_2_0 S_FRAGMENT0();
   }  
}

technique Scale2x_Pass2
{
   pass P0
   {
     VertexShader = compile vs_2_0 S_VERTEX();
     PixelShader  = compile ps_2_0 S_FRAGMENT();
   }  
}