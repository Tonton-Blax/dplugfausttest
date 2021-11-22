
/+ dub.sdl:
	name "mydsp"
	dependency "dplug:core" version="*"
+/
module mydsp;
/* ------------------------------------------------------------
name: "testm"
Code generated with Faust 2.37.3 (https://faust.grame.fr)
Compilation options: -a dplug.d -lang dlang -es 1 -single -ftz 0
------------------------------------------------------------ */
/************************************************************************
 IMPORTANT NOTE : this file contains two clearly delimited sections :
 the ARCHITECTURE section (in two parts) and the USER section. Each section
 is governed by its own copyright and license. Please check individually
 each section for license and copyright information.
 *************************************************************************/

/*******************BEGIN ARCHITECTURE SECTION (part 1/2)****************/

/************************************************************************
 FAUST Architecture File
 Copyright (C) 2003-2019 GRAME, Centre National de Creation Musicale
 ---------------------------------------------------------------------
 This Architecture section is free software; you can redistribute it
 and/or modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 3 of
 the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; If not, see <http://www.gnu.org/licenses/>.
 
 EXCEPTION : As a special exception, you may create a larger work
 that contains this FAUST architecture section and distribute
 that work under terms of your choice, so long as this FAUST
 architecture section is not modified.
 
 ************************************************************************
 ************************************************************************/

// faust -a minimal.d -lang dlang noise.dsp -o noise.d

import dplug.core.vec;
import dplug.client;

alias FAUSTFLOAT = float;

class Meta {
nothrow:
@nogc:
    void declare(string name, string value) {}
}

class UI {
nothrow:
@nogc:
    void declare(string id, string key, string value) {}
    void declare(int id, string key, string value) {}
    void declare(FAUSTFLOAT* id, string key, string value) {}

    // -- layout groups

    void openTabBox(string label) {}
    void openHorizontalBox(string label) {}
    void openVerticalBox(string label) {}
    void closeBox() {}

    // -- active widgets

    void addButton(string label, FAUSTFLOAT* val) {}
    void addCheckButton(string label, FAUSTFLOAT* val) {}
    void addVerticalSlider(string label, FAUSTFLOAT* val, FAUSTFLOAT init, FAUSTFLOAT min, FAUSTFLOAT max, FAUSTFLOAT step) {}
    void addHorizontalSlider(string label, FAUSTFLOAT* val, FAUSTFLOAT init, FAUSTFLOAT min, FAUSTFLOAT max, FAUSTFLOAT step) {}
    void addNumEntry(string label, FAUSTFLOAT* val, FAUSTFLOAT init, FAUSTFLOAT min, FAUSTFLOAT max, FAUSTFLOAT step) {}

    // -- passive display widgets

    void addHorizontalBargraph(string label, FAUSTFLOAT* val, FAUSTFLOAT min, FAUSTFLOAT max) {}
    void addVerticalBargraph(string label, FAUSTFLOAT* val, FAUSTFLOAT min, FAUSTFLOAT max) {}
}

interface dsp {
nothrow:
@nogc:
public:
    void metadata(Meta* m);
    int getNumInputs();
    int getNumOutputs();
    void buildUserInterface(UI* uiInterface);
    int getSampleRate();
    void instanceInit(int sample_rate);
    void instanceResetUserInterface();
    void compute(int count, FAUSTFLOAT*[] inputs, FAUSTFLOAT*[] outputs);
    void initialize(int sample_rate);
}

/**
 * Implements and overrides the methods that would provide parameters for use in 
 * a plug-in or GUI.  These parameters are stored in a vector which can be accesed via
 * `readParams()`
 */
class FaustParamAccess : UI {
nothrow:
@nogc:
    this()
    {
        _faustParams = makeVec!FaustParam();
    }

    override void addButton(string label, FAUSTFLOAT* val)
    {
        _faustParams.pushBack(FaustParam(label, val, 0, 0, 0, 0, true));
    }
    
    override void addCheckButton(string label, FAUSTFLOAT* val)
    {
        _faustParams.pushBack(FaustParam(label, val, 0, 0, 0, 0, true));
    }
    
    override void addVerticalSlider(string label, FAUSTFLOAT* val, FAUSTFLOAT init, FAUSTFLOAT min, FAUSTFLOAT max, FAUSTFLOAT step)
    {
        _faustParams.pushBack(FaustParam(label, val, init, min, max, step));
    }

    override void addHorizontalSlider(string label, FAUSTFLOAT* val, FAUSTFLOAT init, FAUSTFLOAT min, FAUSTFLOAT max, FAUSTFLOAT step)
    {
        _faustParams.pushBack(FaustParam(label, val, init, min, max, step));
    }

    override void addNumEntry(string label, FAUSTFLOAT* val, FAUSTFLOAT init, FAUSTFLOAT min, FAUSTFLOAT max, FAUSTFLOAT step)
    {
        _faustParams.pushBack(FaustParam(label, val, init, min, max, step));
    }

    FaustParam[] readParams()
    {
        return _faustParams.releaseData();
    }

    FaustParam readParam(int index)
    {
        return _faustParams[index];
    }

    ulong length()
    {
        return _faustParams.length();
    }

private:
	Vec!FaustParam _faustParams;
}

struct FaustParam
{
	string label;
	FAUSTFLOAT* val;
	FAUSTFLOAT initial;
	FAUSTFLOAT min;
	FAUSTFLOAT max;
	FAUSTFLOAT step;
    bool isButton = false;
}

version(unittest){}
else
mixin(pluginEntryPoints!FaustClient);

final class FaustClient : dplug.client.Client
{
public:
nothrow:
@nogc:

    this()
    {
        buildFaustModule();
    }

    void buildFaustModule()
    {
        _dsp = mallocNew!(FAUSTCLASS)();
        FaustParamAccess _faustUI = mallocNew!FaustParamAccess();
        _dsp.buildUserInterface(cast(UI*)(&_faustUI));
        _faustParams = _faustUI.readParams();
    }

    override PluginInfo buildPluginInfo()
    {
        // Plugin info is parsed from plugin.json here at compile time.
        // Indeed it is strongly recommended that you do not fill PluginInfo 
        // manually, else the information could diverge.
        static immutable PluginInfo pluginInfo = parsePluginInfo(import("plugin.json"));
        return pluginInfo;
    }

    // This is an optional overload, default is zero parameter.
    // Caution when adding parameters: always add the indices
    // in the same order as the parameter enum.
    override Parameter[] buildParameters()
    {
        auto params = makeVec!Parameter();

        // Add faust parameters
        buildFaustModule();
        int faustParamIndexStart = 0;
        foreach(param; _faustParams)
        {
            if(param.isButton)
            {
                params ~= mallocNew!BoolParameter(faustParamIndexStart++, param.label, cast(bool)(*param.val));
            }
            else
            {
                params ~= mallocNew!LinearFloatParameter(faustParamIndexStart++, param.label, param.label, param.min, param.max, param.initial);
            }
        }

        return params.releaseData();
    }

    override LegalIO[] buildLegalIO()
    {
        auto io = makeVec!LegalIO();
		if(_dsp is null)
		{
			_dsp = mallocNew!(FAUSTCLASS)();
		}
        io ~= LegalIO(_dsp.getNumInputs(), _dsp.getNumOutputs());
        return io.releaseData();
    }

    // This override is optional, the default implementation will
    // have one default preset.
    override Preset[] buildPresets() nothrow @nogc
    {
        auto presets = makeVec!Preset();
        presets ~= makeDefaultPreset();
        return presets.releaseData();
    }

    // This override is also optional. It allows to split audio buffers in order to never
    // exceed some amount of frames at once.
    // This can be useful as a cheap chunking for parameter smoothing.
    // Buffer splitting also allows to allocate statically or on the stack with less worries.
    override int maxFramesInProcess() const //nothrow @nogc
    {
        return 512;
    }

    override void reset(double sampleRate, int maxFrames, int numInputs, int numOutputs) nothrow @nogc
    {
        // Clear here any state and delay buffers you might have.
        _dsp.initialize(cast(int)sampleRate);
        assert(maxFrames <= 512); // guaranteed by audio buffer splitting
    }

    // TODO: use parameter listeners to update the faust param values rather
    // than force updating them on every process call
    void updateFaustParams()
    {
        foreach(param; params())
        {
            foreach(faustParam; _faustParams)
            {
                if(param.label() == faustParam.label)
                {
                    *(faustParam.val) = (cast(FloatParameter)param).value();
                }
            }
        }
    }

    override void processAudio(const(float*)[] inputs, float*[]outputs, int frames,
                               TimeInfo info) nothrow @nogc
    {
        assert(frames <= 512); // guaranteed by audio buffer splitting

        int numInputs = cast(int)inputs.length;
        int numOutputs = cast(int)outputs.length;

        int minChan = numInputs > numOutputs ? numOutputs : numInputs;

        // do reverb
        updateFaustParams();
        _dsp.compute(frames, cast(float*[])inputs, cast(float*[])outputs);

        // fill with zero the remaining channels
        for (int chan = minChan; chan < numOutputs; ++chan)
            outputs[chan][0..frames] = 0; // D has array slices assignments and operations
    }

private:
    FAUSTCLASS _dsp;
    UI _faustUI;
    FaustParam[] _faustParams;
}

/******************************************************************************
 *******************************************************************************
 
 VECTOR INTRINSICS
 
 *******************************************************************************
 *******************************************************************************/


/********************END ARCHITECTURE SECTION (part 1/2)****************/

/**************************BEGIN USER SECTION **************************/

import std.math;
import std.algorithm : min, max;
import dplug.core.nogc: mallocNew, mallocSlice, destroyFree, assumeNothrowNoGC;
alias FAUSTCLASS = mydsp;

class mydsp : dsp
{
nothrow:
@nogc:
	
 private:
	
	FAUSTFLOAT fHslider0;
	FAUSTFLOAT fButton0;
	int fSampleRate;
	float fConst0;
	FAUSTFLOAT fHslider1;
	FAUSTFLOAT fHslider2;
	int[2] iVec0;
	float[2] fRec0;
	float[2] fRec1;
	
 public:
	
	void metadata(Meta* m) nothrow @nogc { 
		m.declare("basics.lib/name", "Faust Basic Element Library");
		m.declare("basics.lib/version", "0.1");
		m.declare("compile_options", "-a dplug.d -lang dlang -es 1 -single -ftz 0");
		m.declare("filename", "testm.dsp");
		m.declare("filters.lib/lowpass0_highpass1", "MIT-style STK-4.3 license");
		m.declare("filters.lib/name", "Faust Filters Library");
		m.declare("filters.lib/nlf2:author", "Julius O. Smith III");
		m.declare("filters.lib/nlf2:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m.declare("filters.lib/nlf2:license", "MIT-style STK-4.3 license");
		m.declare("filters.lib/version", "0.3");
		m.declare("maths.lib/author", "GRAME");
		m.declare("maths.lib/copyright", "GRAME");
		m.declare("maths.lib/license", "LGPL with exception");
		m.declare("maths.lib/name", "Faust Math Library");
		m.declare("maths.lib/version", "2.3");
		m.declare("name", "testm");
		m.declare("oscillators.lib/name", "Faust Oscillator Library");
		m.declare("oscillators.lib/version", "0.1");
		m.declare("platform.lib/name", "Generic Platform Library");
		m.declare("platform.lib/version", "0.1");
	}

	int getNumInputs() nothrow @nogc {
		return 0;
	}
	int getNumOutputs() nothrow @nogc {
		return 2;
	}
	
	static void classInit(int sample_rate) nothrow @nogc {
	}
	
	void instanceConstants(int sample_rate) nothrow @nogc {
		fSampleRate = sample_rate;
		fConst0 = (6.28318548 / fmin(192000.0, fmax(1.0, cast(float)fSampleRate)));
	}
	
	void instanceResetUserInterface() nothrow @nogc {
		fHslider0 = cast(FAUSTFLOAT)1.0;
		fButton0 = cast(FAUSTFLOAT)0.0;
		fHslider1 = cast(FAUSTFLOAT)392.0;
		fHslider2 = cast(FAUSTFLOAT)0.0;
	}
	
	void instanceClear() nothrow @nogc {
		for (int l0 = 0; (l0 < 2); l0 = (l0 + 1)) {
			iVec0[l0] = 0;
		}
		for (int l1 = 0; (l1 < 2); l1 = (l1 + 1)) {
			fRec0[l1] = 0.0;
		}
		for (int l2 = 0; (l2 < 2); l2 = (l2 + 1)) {
			fRec1[l2] = 0.0;
		}
	}
	
	void initialize(int sample_rate) nothrow @nogc {
		classInit(sample_rate);
		instanceInit(sample_rate);
	}
	void instanceInit(int sample_rate) nothrow @nogc {
		instanceConstants(sample_rate);
		instanceResetUserInterface();
		instanceClear();
	}
	
	mydsp clone() {
		return (mallocNew!mydsp());
	}
	
	int getSampleRate() nothrow @nogc {
		return fSampleRate;
	}
	
	void buildUserInterface(UI* uiInterface) nothrow @nogc {
		uiInterface.openVerticalBox("testm");
		uiInterface.declare(&fHslider2, "midi", "pitchwheel");
		uiInterface.addHorizontalSlider("bend", &fHslider2, cast(FAUSTFLOAT)0.0, cast(FAUSTFLOAT)-2.0, cast(FAUSTFLOAT)2.0, cast(FAUSTFLOAT)0.00100000005);
		uiInterface.addHorizontalSlider("freq", &fHslider1, cast(FAUSTFLOAT)392.0, cast(FAUSTFLOAT)200.0, cast(FAUSTFLOAT)450.0, cast(FAUSTFLOAT)0.00999999978);
		uiInterface.declare(&fHslider0, "midi", "ctrl 7");
		uiInterface.addHorizontalSlider("gain", &fHslider0, cast(FAUSTFLOAT)1.0, cast(FAUSTFLOAT)0.0, cast(FAUSTFLOAT)1.0, cast(FAUSTFLOAT)0.00100000005);
		uiInterface.addButton("gate", &fButton0);
		uiInterface.closeBox();
	}
	
	void compute(int count, FAUSTFLOAT*[] inputs, FAUSTFLOAT*[] outputs) nothrow @nogc {
		FAUSTFLOAT* output0 = outputs[0];
		FAUSTFLOAT* output1 = outputs[1];
		float fSlow0 = (cast(float)fHslider0 * cast(float)fButton0);
		float fSlow1 = (fConst0 * (cast(float)fHslider1 * pow(2.0, (0.0833333358 * cast(float)fHslider2))));
		float fSlow2 = sin(fSlow1);
		float fSlow3 = cos(fSlow1);
		for (int i0 = 0; (i0 < count); i0 = (i0 + 1)) {
			iVec0[0] = 1;
			fRec0[0] = ((fSlow2 * fRec1[1]) + (fSlow3 * fRec0[1]));
			fRec1[0] = ((cast(float)(1 - iVec0[1]) + (fSlow3 * fRec1[1])) - (fSlow2 * fRec0[1]));
			float fTemp0 = (fSlow0 * fRec0[0]);
			output0[i0] = cast(FAUSTFLOAT)fTemp0;
			output1[i0] = cast(FAUSTFLOAT)fTemp0;
			iVec0[1] = iVec0[0];
			fRec0[1] = fRec0[0];
			fRec1[1] = fRec1[0];
		}
	}

}

/***************************END USER SECTION ***************************/

/*******************BEGIN ARCHITECTURE SECTION (part 2/2)***************/

/********************END ARCHITECTURE SECTION (part 2/2)****************/

