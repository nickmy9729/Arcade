/*
   Scale2x shader 

           - Copyright (C) 2007 guest(r) - guest.r@gmail.com

           - License: GNU-GPL  


   The Scale2x algorithm:

           - Scale2x Homepage: http://scale2x.sourceforge.net/

           - Copyright (C) 2001, 2002, 2003, 2004 Andrea Mazzoleni 
		
           - License: GNU-GPL  

*/



#include "shader.code"

string preprocessTechique : PREPROCESSTECHNIQUE = "Scale2xPlus";
string combineTechique : COMBINETECHNIQUE =  "SF";

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

	half2 dx = half2(ps.x, 0.0)*2; 
	half2 dy = half2( 0.0,ps.y)*2;
	
	float2 pixcoord  = 0.5*VAR.CT/ps;
	float2 fp        = frac(pixcoord);
	float2 d11       = VAR.CT-fp*ps;


	// Reading the texels

	half3 B = tex2D(s_p,d11-dy).xyz;
	half3 D = tex2D(s_p,d11-dx).xyz;
	half3 E = tex2D(s_p,d11   ).xyz;
	half3 F = tex2D(s_p,d11+dx).xyz;
	half3 H = tex2D(s_p,d11+dy).xyz;
	
	
	// The Scale2x algorithm

	half3 E0 = D == B && B != H && D != F ? D : E;
	half3 E1 = B == F && B != H && D != F ? F : E;
	half3 E2 = D == H && B != H && D != F ? D : E;
	half3 E3 = H == F && B != H && D != F ? F : E;


	// Product interpolation
	
	fp = 1-step(fp,0.5);

	return float4((E3*fp.x+E2*(1-fp.x))*fp.y+(E1*fp.x+E0*(1-fp.x))*(1-fp.y),1); 
}

VERTEX_STUFF4 _VERTEX0 (float3 p : POSITION, float2 tc : TEXCOORD0)
{
  VERTEX_STUFF4 OUT = (VERTEX_STUFF4)0;
  
	float dx = ps.x*0.5;
	float dy = ps.y*0.5;
	float2 d1 = float2( dx,dy);
	float2 d2 = float2(-dx,dy);

	OUT.coord = mul(float4(p,1),WorldViewProjection);
	OUT.CT = tc;

	OUT.t1.xy = float2(tc).xy - d1; 
	OUT.t2.xy = float2(tc).xy - d2;
	OUT.t3.xy = float2(tc).xy + d1; 
	OUT.t4.xy = float2(tc).xy + d2;

	return OUT;
}


// **PS**

float4 _FRAGMENT0 ( in VERTEX_STUFF4 VAR ) : COLOR

{
	float2 x = float2(ps.x*0.5,0);
	float2 y = float2(0,ps.y*0.5);

	float3 c00, c02, c20, c22, c11, u, d, r, l;
	float m1, m2;

	c00 = tex2D(w_l, VAR.t1.xy-y).xyz; 
	c20 = tex2D(w_l, VAR.t2.xy-y).xyz; 
	c02 = tex2D(w_l, VAR.t4.xy-y).xyz; 
	c22 = tex2D(w_l, VAR.t3.xy-y).xyz; 

	m1 = dot(abs(c00-c22),dt)+0.001;
	m2 = dot(abs(c02-c20),dt)+0.001;

	u = (m2*(c00+c22)+m1*(c02+c20))/(m1+m2);

	c00 = tex2D(w_l, VAR.t1.xy+y).xyz; 
	c20 = tex2D(w_l, VAR.t2.xy+y).xyz; 
	c02 = tex2D(w_l, VAR.t4.xy+y).xyz; 
	c22 = tex2D(w_l, VAR.t3.xy+y).xyz; 
	
	m1 = dot(abs(c00-c22),dt)+0.001;
	m2 = dot(abs(c02-c20),dt)+0.001;

	d = (m2*(c00+c22)+m1*(c02+c20))/(m1+m2);

	c00 = tex2D(w_l, VAR.t1.xy-x).xyz; 
	c20 = tex2D(w_l, VAR.t2.xy-x).xyz; 
	c02 = tex2D(w_l, VAR.t4.xy-x).xyz; 
	c22 = tex2D(w_l, VAR.t3.xy-x).xyz; 

	m1 = dot(abs(c00-c22),dt)+0.001;
	m2 = dot(abs(c02-c20),dt)+0.001;

	l = (m2*(c00+c22)+m1*(c02+c20))/(m1+m2);

	c00 = tex2D(w_l, VAR.t1.xy+x).xyz; 
	c20 = tex2D(w_l, VAR.t2.xy+x).xyz; 
	c02 = tex2D(w_l, VAR.t4.xy+x).xyz; 
	c22 = tex2D(w_l, VAR.t3.xy+x).xyz; 

	m1 = dot(abs(c00-c22),dt)+0.001;
	m2 = dot(abs(c02-c20),dt)+0.001;

	r = (m2*(c00+c22)+m1*(c02+c20))/(m1+m2);

	c11 = 0.125*(u+d+r+l);

	float2 dx  = float2(ps.x,0.0);
	float2 dy  = float2(0.0,ps.y);
	float2 g1  = float2( ps.x,ps.y);
	float2 g2  = float2(-ps.x,ps.y);
	float2 pC4 = VAR.CT;

	
	// Reading the texels
 
	float3 C0 = tex2D(w_l,pC4-g1).xyz; 
	float3 C1 = tex2D(w_l,pC4-dy).xyz;
	float3 C2 = tex2D(w_l,pC4-g2).xyz;
	float3 C3 = tex2D(w_l,pC4-dx).xyz;
	float3 C4 = tex2D(w_l,pC4   ).xyz;
	float3 C5 = tex2D(w_l,pC4+dx).xyz;
	float3 C6 = tex2D(w_l,pC4+g2).xyz;
	float3 C7 = tex2D(w_l,pC4+dy).xyz;
	float3 C8 = tex2D(w_l,pC4+g1).xyz;
 
	float3 mn1 = min(min(C0,C1),C2);
	float3 mn2 = min(min(C3,C4),C5);
	float3 mn3 = min(min(C6,C7),C8);
	float3 mx1 = max(max(C0,C1),C2);
	float3 mx2 = max(max(C3,C4),C5);
	float3 mx3 = max(max(C6,C7),C8);
 
	mn1 = min(min(mn1,mn2),mn3);
	mx1 = max(max(mx1,mx2),mx3);
 
	float3 dif1 = abs(c11-mn1) + 0.001*dt;
	float3 dif2 = abs(c11-mx1) + 0.001*dt;
 
 //  float filterparam = 2.5; 
 
	float3 dif = sqrt(mx1)-sqrt(mn1);    
	float filterparam = clamp(4.0*max(dif.x,max(dif.y,dif.z)),1.0,2.4);

	dif1=float3(pow(dif1.x,filterparam),pow(dif1.y,filterparam),pow(dif1.z,filterparam));
	dif2=float3(pow(dif2.x,filterparam),pow(dif2.y,filterparam),pow(dif2.z,filterparam));
 
	c11.r = (dif1.x*mx1.x + dif2.x*mn1.x)/(dif1.x + dif2.x);
	c11.g = (dif1.y*mx1.y + dif2.y*mn1.y)/(dif1.y + dif2.y);
	c11.b = (dif1.z*mx1.z + dif2.z*mn1.z)/(dif1.z + dif2.z);
	
	// r  = length(c11);
	// c11= float3(pow(c11,1.175));
        // c11=hd(r)*normalize(c11);

	return float4(c11,1);
}


technique Scale2xPlus
{
   pass P0
   {
     VertexShader = compile vs_2_0 _VERTEX();
     PixelShader  = compile ps_2_0 _FRAGMENT();
   }  
}

technique SF
{
   pass P0
   {
     VertexShader = compile vs_3_0 _VERTEX0();
     PixelShader  = compile ps_3_0 _FRAGMENT0();
   }  
}