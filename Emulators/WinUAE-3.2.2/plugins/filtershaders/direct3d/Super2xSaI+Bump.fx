/*
   Super2xSaI shader 

           - Copyright (C) 2007-2011 guest(r) - guest.r@gmail.com
           - License: GNU-GPL  
           - november 2011 - added linear last pass

   The Super2xSaI algorithm

           - Copyright (c) 1999-2001 by Derek Liauw Kie Fa.		

*/


#include "shader.code"


string preprocessTechique : PREPROCESSTECHNIQUE = "Super2xSaI";
string combineTechique : COMBINETECHNIQUE =  "Bump";

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

       
       if (c7 == c5 && c4 != c8) {
                p11 = p01 = C7;
        } else if (c4 == c8 && c7 != c5) {
                p11 = p01 = C4;
        } else if (c4 == c8 && c7 == c5) {
                int r = 0;
                r += GET_RESULT(c5,c4,c6,d1);
                r += GET_RESULT(c5,c4,c3,c1);
                r += GET_RESULT(c5,c4,d2,d5);
                r += GET_RESULT(c5,c4,c2,d4);

                if (r > 0)
                        p11 = p01 = C5;
                else if (r < 0)
                        p11 = p01 = C4;
                else {
                        p11 = p01 = 0.5*(C4+C5);
                }
        } else {
                if (c5 == c8 && c8 == d1 && c7 != d2 && c8 != d0)
                        p11 = 0.25*(3.0*C8+C7);
                else if (c4 == c7 && c7 == d2 && d1 != c8 && c7 != d6)
                        p11 = 0.25*(3.0*C7+C8);
                else
                        p11 = 0.5*(C7+C8);

                if (c5 == c8 && c5 == c1 && c4 != c2 && c5 != c0)
                        p01 = 0.25*(3.0*C5+C4);
                else if (c4 == c7 && c4 == c2 && c1 != c5 && c4 != d3)
                        p01 = 0.25*(3.0*C4+C5);
                else
                        p01 = 0.5*(C4+C5);
        }

        if (c4 == c8 && c7 != c5 && c3 == c4 && c4 != d2)
                p10 = 0.5*(C7+C4);
        else if (c4 == c6 && c5 == c4 && c3 != c7 && c4 != d0)
                p10 = 0.5*(C7+C4);
        else
                p10 = C7;

        if (c7 == c5 && c4 != c8 && c6 == c7 && c7 != c2)
                p00 = 0.5*(C7+C4);
        else if (c3 == c7 && c8 == c7 && c6 != c4 && c7 != c0)
                p00 = 0.5*(C7+C4);
        else
                p00 = C4;


	// Distributing the four products
	
	if (fp.x < 0.50)
		{ if (fp.y < 0.50) p10 = p00;}
	else
		{ if (fp.y < 0.50) p10 = p01; else p10 = p11;}

	return float4(p10,1); 
}

VERTEX_STUFF4 _VERTEX0 (float3 p : POSITION, float2 tc : TEXCOORD0)
{
  VERTEX_STUFF4 OUT = (VERTEX_STUFF4)0;
  
  float dx = ps.x*0.5;
  float dy = ps.y*0.5;

  OUT.coord = mul(float4(p,1),WorldViewProjection);
  OUT.CT = tc;

  OUT.t1 = float4(tc,tc) + float4(-dx,-dy, dx,-dy); // outer diag. texels
  OUT.t2 = float4(tc,tc) + float4( dx, dy,-dx, dy);
  OUT.t5 = float4(tc,tc) + float4(-dx,  0, dx,  0); // inner hor/vert texels
  OUT.t6 = float4(tc,tc) + float4(  0,-dy,  0, dy);

return OUT;
}


// **PS**

float4 _FRAGMENT0 ( in VERTEX_STUFF4 VAR ) : COLOR

{
  half3 c11 = tex2D(w_l, VAR.CT   ).xyz;
  half3 c00 = tex2D(w_l, VAR.t1.xy).xyz;
  half3 c20 = tex2D(w_l, VAR.t1.zw).xyz;
  half3 c22 = tex2D(w_l, VAR.t2.xy).xyz;
  half3 c02 = tex2D(w_l, VAR.t2.zw).xyz;
  half3 c01 = tex2D(w_l, VAR.t5.xy).xyz;
  half3 c21 = tex2D(w_l, VAR.t5.zw).xyz;
  half3 c10 = tex2D(w_l, VAR.t6.xy).xyz;
  half3 c12 = tex2D(w_l, VAR.t6.zw).xyz;

  float d1 = dot(abs(c00-c22),dt)+0.001;
  float d2 = dot(abs(c20-c02),dt)+0.001;
  float hl = dot(abs(c01-c21),dt)+0.001;
  float vl = dot(abs(c10-c12),dt)+0.001;

  float md = d1+d2;   float mc = hl+vl;
  hl*=  md;vl*= md;   d1*=  mc;d2*= mc;
	
  float ww = d1+d2+hl+vl;

  float3 d11 = (hl*(c10+c12)+vl*(c01+c21)+d1*(c20+c02)+d2*(c00+c22)+ww*c11)/(3.0*ww);

  c11 = (-c00+c22-c01+c21-c10+c12+4*c11)/4;

  float dif1 = length(c11)-length(d11);
  float dif2 = length(d11) + dif1*1.25;

  c11 = normalize(c11)*dif2;
  c11 = min(c11,1.15*d11);
  c11 = max(c11,0.92*d11);

  float k1 = length(c11); d1 = 0.57735*k1;

  c11 = pow(c11,float3(1.125,1.125,1.125));

  d2 = (1.0-d1)*k1+d1*normalize(float2(k1*k1,0.866)).x*1.73205;

  c11 = normalize(c11)*(k1+0.65*d2)/1.65;

  return float4(c11,1);
}

technique Super2xSaI
{
   pass P0
   {
     VertexShader = compile vs_3_0 _VERTEX();
     PixelShader  = compile ps_3_0 _FRAGMENT();
   }  
}

technique Bump
{
   pass P0
   {
     VertexShader = compile vs_3_0 _VERTEX0();
     PixelShader  = compile ps_3_0 _FRAGMENT0();
   }  
}