
#include "DrumMachine.h"

using namespace GE;

const char *drum_sample_files[DRUM_MACHINE_SAMPLE_COUNT] = {
    ":/sounds/hihat.wav",
    ":/sounds/hihat_open.wav",
    ":/sounds/bassd.wav",
    ":/sounds/snare.wav",
    ":/sounds/cymbal.wav",
    ":/sounds/cowbell.wav"
};


const unsigned char drum_seq0[] = { 5, 0, 1, 0, 9, 0, 5, 0,
                                    5, 0, 1, 0, 9, 4, 2, 0,
                                    5, 0, 1, 0, 9, 0, 1, 4,
                                    1, 4, 1, 0, 9, 0, 2, 0};

const unsigned char drum_seq1[] = {21, 0, 1, 0,14, 0, 0, 0,
                                    5, 0, 1, 0,14, 0, 0, 8,
                                    5, 0, 1, 0,14, 0, 0, 0,
                                    5, 2, 0, 0, 6, 0, 1, 8,
                                   21, 0, 1, 0,14, 0, 0, 0,
                                    5, 0, 1, 0,14, 0, 0, 8,
                                    5, 0, 1, 0,14, 0, 0, 0,
                                    5, 2, 0, 0,14,12,13,13};

const unsigned char drum_seq2[] = { 5, 0, 1, 0,33, 0, 5, 0,
                                    5, 0, 1, 0,33, 0, 2, 0};

const unsigned char drum_seq3[] = { 5, 0, 1, 0,10, 4, 1, 0,
                                    5, 0, 1, 0,10, 4, 5, 4};


CDrumMachine::CDrumMachine()
{
    m_mixer = new CAudioMixer();

    for (int i=0; i<DRUM_MACHINE_SAMPLE_COUNT; i++) {
        m_drumSamples[i] =  CAudioBuffer::loadWav(QString(drum_sample_files[i]));
        m_playInstances[i] = new CAudioBufferPlayInstance;
        m_playInstances[i]->setDestroyWhenFinished(false);            // dont destroy object when playing is finished>
        m_mixer->addAudioSource(m_playInstances[i]);
    }

    m_running = false;
    m_seq = NULL;
    m_seqLen = 0;
    m_tickCount = 0;
    setBpm(600);
}


CDrumMachine::~CDrumMachine()
{
    delete m_mixer;
    m_mixer = NULL;

    for (int f=0; f<DRUM_MACHINE_SAMPLE_COUNT; f++) {
        if (m_drumSamples[f]) {
            delete m_drumSamples[f];
        }
    }

    setSeq(0,0);
}


void CDrumMachine::setSeq( const unsigned char *seq, int seqLen )
{
    if(m_seq != NULL) {
        delete [] m_seq;
    }

    m_seq = NULL;
    m_seqLen = 0;

    if(seq == NULL) {
        return;
    }

    m_seq = new unsigned char[seqLen];
    memcpy(m_seq, seq, seqLen);
    m_seqLen = seqLen;
}


void CDrumMachine::setBpm( int bpm )
{
    m_bpm = bpm;
    m_samplesPerTick = (AUDIO_FREQUENCY * 60) / m_bpm;
    m_sampleCounter = 0;
}


/**
 *
 * Run the drum machine.
 *
 */
void CDrumMachine::tick()
{
    if(!m_running) {
        return;
    }

    if(!m_seq) {
        return;
    }
    if (m_tickCount >= m_seqLen) {
        m_tickCount = 0;
    }
    unsigned char sbyte = m_seq[m_tickCount];

    float setvol = 1.0f;
    for (int f=0; f<DRUM_MACHINE_SAMPLE_COUNT; f++) {
        if (sbyte & (1 << f)) {
            m_playInstances[f]->playBuffer(m_drumSamples[f], setvol, 1.0f);
        }
    }

    m_tickCount++;
}


int CDrumMachine::pullAudio(AUDIO_SAMPLE_TYPE *target, int length)
{
    m_mixer->setGeneralVolume(2.5f / (float)DRUM_MACHINE_SAMPLE_COUNT);

    int pos = 0;
    while (pos < length) {
        int sampleMixCount = ((length-pos)>>1);
        int samplesBeforeNextTick = m_samplesPerTick - m_sampleCounter;
        if(sampleMixCount > samplesBeforeNextTick) sampleMixCount = samplesBeforeNextTick;

        if(sampleMixCount > 0) {
            int mixed = m_mixer->pullAudio( target, sampleMixCount*2 );
            if(mixed < 1) {
                return 0;              // fatal error
            }
            pos += mixed;
            target += mixed;
            m_sampleCounter += (mixed >> 1);
        }

        if(m_sampleCounter >= m_samplesPerTick) {
            tick();
            m_sampleCounter -= m_samplesPerTick;
        }
    }

    return length;
}


void CDrumMachine::setDemoBeat(QVariant index)
{
    switch (index.toInt()) {
    default:
        setSeq(0,0);
        break;
    case 0:
        setSeq(drum_seq0, 64);
        break;
    case 1:
        setSeq(drum_seq1, 16);
        break;
    case 2:
        setSeq(drum_seq2, 16);
        break;
    case 3:
        setSeq(drum_seq3, 32);
        break;
    };

    // Resets the DrumButtons in UI
    emit drumButtons(getSeqLen(), getSampleCount());
};
