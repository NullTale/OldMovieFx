using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

//  OldMovieFx © NullTale - https://twitter.com/NullTale/
namespace VolFx
{
    [Serializable, VolumeComponentMenu("VolFx/Old Movie")]
    public sealed class OldMovieVol : VolumeComponent, IPostProcessComponent
    {
        public ClampedFloatParameter         m_Grain      = new ClampedFloatParameter(0f, 0f, 1f);
        public NoiseParameter                m_Noise      = new NoiseParameter(OldMoviePass.Noise.None, false);
        public ClampedFloatParameter         m_NoiseAlpha = new ClampedFloatParameter(1f, 0f, 1f);
        public ClampedFloatParameter         m_Jolt       = new ClampedFloatParameter(0f, 0f, 1f);
        public NoInterpClampedFloatParameter m_Fps        = new NoInterpClampedFloatParameter(16, 0f, 60);
        public ColorParameter                m_Vignette   = new ColorParameter(Color.clear);
        public GrainParameter                m_GrainTex   = new GrainParameter(OldMoviePass.GrainTex.Thin_A, false);

        // =======================================================================
        [Serializable]
        public class GrainParameter : VolumeParameter<OldMoviePass.GrainTex>
        {
            public GrainParameter(OldMoviePass.GrainTex value, bool overrideState) : base(value, overrideState) { }
        } 
        
        [Serializable]
        public class NoiseParameter : VolumeParameter<OldMoviePass.Noise>
        {
            public NoiseParameter(OldMoviePass.Noise value, bool overrideState) : base(value, overrideState) { }
        } 
        
        // =======================================================================
        public bool IsActive() => m_Jolt.value > 0f || m_Grain.value > 0 || m_Vignette.value.a > 0f;

        public bool IsTileCompatible() => true;
    }
}