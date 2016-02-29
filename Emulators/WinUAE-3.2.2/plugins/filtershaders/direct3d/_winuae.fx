// 3 (version)
//
// WinUAE Direct3D post processing shader
//
// by Toni Wilen 2012

uniform extern float4x4 mtx;
uniform extern float2 maskmult;
uniform extern float2 maskshift;
uniform extern int filtermode;
uniform extern float2 texelsize;

// final possibly filtered Amiga output
texture SourceTexture : SOURCETEXTURE;

sampler	SourceSampler = sampler_state {
	Texture	  = (SourceTexture);
	MinFilter = filtermode;
	MagFilter = filtermode;
	MipFilter = NONE;
	AddressU  = Clamp;
	AddressV  = Clamp;
};


texture OverlayTexture : OVERLAYTEXTURE;

sampler	OverlaySampler = sampler_state {
	Texture	  = (OverlayTexture);
	MinFilter = POINT;
	MagFilter = POINT;
	MipFilter = NONE;
	AddressU  = Wrap;
	AddressV  = Wrap;
};

struct VS_OUTPUT_POST
{
	float4 Position		: POSITION;
	float2 CentreUV		: TEXCOORD0;
	float2 Selector		: TEXCOORD1;
};

VS_OUTPUT_POST VS_Post(float3 pos : POSITION, float2 TexCoord : TEXCOORD0)
{
	VS_OUTPUT_POST Out = (VS_OUTPUT_POST)0;

	Out.Position = mul(float4(pos, 1.0f), mtx);
	Out.CentreUV = TexCoord;
	Out.Selector = TexCoord * maskmult + maskshift;
	return Out;
}

float4 PS_Post(in VS_OUTPUT_POST inp) : COLOR
{
	float4 s = tex2D(SourceSampler, inp.CentreUV);
	float4 o = tex2D(OverlaySampler, inp.Selector);
	return s * o;
}

float4 PS_PostAlpha(in VS_OUTPUT_POST inp) : COLOR
{
	float4 s = tex2D(SourceSampler, inp.CentreUV);
	float4 o = tex2D(OverlaySampler, inp.Selector);
	return s * (1 - o.a) + (o * o.a);
}

float4 PS_PostPlain(in VS_OUTPUT_POST inp) : COLOR
{
	float4 s = tex2D(SourceSampler, inp.CentreUV);
	return s;
}

// source and overlay texture
technique PostTechnique
{
    pass P0
    {
		VertexShader = compile vs_1_0 VS_Post();
		PixelShader  = compile ps_2_0 PS_Post();
    }  
}

// source and scanline texture with alpha
technique PostTechniqueAlpha
{
	pass P0
	{
		VertexShader = compile vs_1_0 VS_Post();
		PixelShader  = compile ps_2_0 PS_PostAlpha();
    } 
}

// only source texture
technique PostTechniquePlain
{
	pass P0
	{
		VertexShader = compile vs_1_0 VS_Post();
		PixelShader  = compile ps_2_0 PS_PostPlain();
    }
}
