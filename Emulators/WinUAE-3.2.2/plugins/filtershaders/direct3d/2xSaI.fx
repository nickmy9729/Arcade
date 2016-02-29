/*
   2xSaI shader 

           - Copyright (C) 2007-2011 guest(r) - guest.r@gmail.com
           - License: GNU-GPL
           - november 2011 - added linear last pass

   The 2xSaI algorithm

           - Copyright (c) 1999-2001 by Derek Liauw Kie Fa.		

*/



#include "shader.code"

string preprocessTechique : PREPROCESSTECHNIQUE = "SaI";
string combineTechique : COMBINETECHNIQUE =  "Linear";

const float3 dtt = float3(65536,255,1);



/*  GET_RESULT function                            */
/*  Copyright (c) 1999-2001 by Derek Liauw Kie Fa  */
/*  License: GNU-GPL                               */


int GET_RESULT(float A, float B, float C, float D)
{
	int x = 0; int y = 0; int r = 0;
	if (A == C) x+=1; else if (B == C) y+=1;
	if (A == D) x+=1; else if (B == D) y+=1;
	if (x <= 1) r+=1; 
	if (y <= 1) r-=1;
	return r;
} 


float reduce(half3 color)
{ 
	return dot(color,dtt);
}

// **VS**

VERTEX_STUFF_W _VERTEX (float3 p : POSITION, float2 tc : TEXCOORD0)
{
	VERTEX_STUFF_W OUT = (VERTEX_STUFF_W)0;

	OUT.coord = mul(float4(p,1),WorldViewProjection);
	OUT.CT = tc;
	return OUT;
}

// **PS**

float4 _FRAGMENT ( in VERTEX_STUFF_W VAR ) : COLOR
{
	// calculating offsets, coordinates

	half2 dx = half2( ps.x, 0.0)*2; 
	half2 dy = half2( 0.0, ps.y)*2;
	half2 g1 = half2( ps.x,ps.y)*2;
	half2 g2 = half2(-ps.x,ps.y)*2;	
	
	float2 pixcoord  = 0.5*VAR.CT/ps;
	float2 fp        = frac(pixcoord);
	float2 pC4       = VAR.CT-fp*ps;
	float2 pC8       = pC4+g1;

	

	// Reading the texels

	half3 C0 = tex2D(s_p,pC4-g1).xyz; 
	half3 C1 = tex2D(s_p,pC4-dy).xyz;
	half3 C2 = tex2D(s_p,pC4-g2).xyz;
	half3 D3 = tex2D(s_p,pC4-g2+dx).xyz;
	half3 C3 = tex2D(s_p,pC4-dx).xyz;
	half3 C4 = tex2D(s_p,pC4   ).xyz;
	half3 C5 = tex2D(s_p,pC4+dx).xyz;
	half3 D4 = tex2D(s_p,pC8-g2).xyz;
	half3 C6 = tex2D(s_p,pC4+g2).xyz;
	half3 C7 = tex2D(s_p,pC4+dy).xyz;
	half3 C8 = tex2D(s_p,pC4+g1).xyz;
	half3 D5 = tex2D(s_p,pC8+dx).xyz;
	half3 D0 = tex2D(s_p,pC4+g2+dy).xyz;
	half3 D1 = tex2D(s_p,pC8+g2).xyz;
	half3 D2 = tex2D(s_p,pC8+dy).xyz;
	half3 D6 = tex2D(s_p,pC8+g1).xyz;

	float3 p00,p10,p01,p11;
	
	float c0 = reduce(C0);float c1 = reduce(C1);
	float c2 = reduce(C2);float c3 = reduce(C3);
	float c4 = reduce(C4);float c5 = reduce(C5);
	float c6 = reduce(C6);float c7 = reduce(C7);
	float c8 = reduce(C8);float d0 = reduce(D0);
	float d1 = reduce(D1);float d2 = reduce(D2);
	float d3 = reduce(D3);float d4 = reduce(D4);
	float d5 = reduce(D5);float d6 = reduce(D6);

	
	if ((c4 == c8) && (c5 != c7)) {
		if (((c4 == c1) && (c5 == d5)) ||
			((c4 == c7) && (c4 == c2) && (c5 != c1) && (c5 == d3))) {
				p01 = C4;
		} else {
			p01 = 0.5*(C4+C5);
		}

		if (((c4 == c3) && (c7 == d2)) ||
			((c4 == c5) && (c4 == c6) && (c3 != c7)  && (c7 == d0))) {
				p10 = C4;
		} else {
			p10 = 0.5*(C4+C7);
		}
		p11 = C4;
	} else if ((c5 == c7) && (c4 != c8)) {
		if (((c5 == c2) && (c4 == c6)) ||
			((c5 == c1) && (c5 == c8) && (c4 != c2) && (c4 == c0))) {
				p01 = C5;
		} else {
			p01 = 0.5*(C4+C5);
		}

		if (((c7 == c6) && (c4 == c2)) ||
			((c7 == c3) && (c7 == c8) && (c4 != c6) && (c4 == c0))) {
				p10 = C7;
		} else {
			p10 = 0.5*(C4+C7);
		}
		p11 = C5;
	} else if ((c4 == c8) && (c5 == c7)) {
		if (c4 == c5) {
			p01 = C4;
			p10 = C4;
			p11 = C4;
		} else {
			float r;
			r  = GET_RESULT(c4,c5,c3,c1);
			r -= GET_RESULT(c5,c4,d4,c2);
			r -= GET_RESULT(c5,c4,c6,d1);
			r += GET_RESULT(c4,c5,d5,d2);

			if (r > 0.0)
				p11 = C4;
			else if (r < 0.0)
				p11 = C5;
			else {
				p11 = 0.25*(C4+C5+C7+C8);
			}

			p10 = 0.5*(C4+C7);
			p01 = 0.5*(C4+C5);
		}
	} else {
		p11 = 0.25*(C4+C5+C7+C8);

		if ((c4 == c7) && (c4 == c2)
			&& (c5 != c1) && (c5 == c3)) {
				p01 = C4;
		} else if ((c5 == c1) && (c5 == c8)
			&& (c4 != c2) && (c4 == c0)) {
				p01 = C5;
		} else {
			p01 = 0.5*(C4+C5);
		}

		if ((c4 == c5) && (c4 == c6)
			&& (c3 != c7) && (c7 == d0)) {
				p10 = C4;
		} else if ((c7 == c3) && (c7 == c8)
			&& (c4 != c6) && (c4 == c0)) {
				p10 = C7;
		} else {
			p10 = 0.5*(C4+C7);
		} 
	}
	p00 = C4; 

	if (fp.x < 0.50)
		{ if (fp.y < 0.50) p10 = p00;}
	else
		{ if (fp.y < 0.50) p10 = p01; else p10 = p11;}

	return float4(p10,1); 
}

VERTEX_STUFF0 _VERTEX0 (float3 p : POSITION, float2 tc : TEXCOORD0)
{
  VERTEX_STUFF0 OUT = (VERTEX_STUFF0)0;
  
  OUT.coord = mul(float4(p,1),WorldViewProjection);
  OUT.CT = tc;

  return OUT;
}


float4 _FRAGMENT0 ( in VERTEX_STUFF0 VAR ) : COLOR
{

   half3 c11 = tex2D(w_l, VAR.CT).xyz; 

   return float4 (c11,1);
}

technique SaI
{
   pass P0
   {
     VertexShader = compile vs_3_0 _VERTEX();
     PixelShader  = compile ps_3_0 _FRAGMENT();
   }  
}

technique Linear
{
   pass P0
   {
     VertexShader = compile vs_2_0 _VERTEX0();
     PixelShader  = compile ps_2_0 _FRAGMENT0();
   }  
}