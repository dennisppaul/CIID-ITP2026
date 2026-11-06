// Ordinary MIDI keeps its channel-based musical parts. Known pad/mixer inputs
// learn their note/CC numbers on first use: no factory preset is assumed.
final int MAX_PORTS=4, PART_LIMIT=16*(MAX_PORTS+1);
ArrayList<MidiPort> hardwareInputs=new ArrayList<MidiPort>();
java.util.concurrent.ConcurrentLinkedQueue<Runnable> incomingMidi=new java.util.concurrent.ConcurrentLinkedQueue<Runnable>();
MidiEnergy audio=new MidiEnergy();
boolean transportRunning=true;
int midiIndex=-1, parts, ticks, receivedMessages;
String inputStatus="Connect MIDI hardware; I reconnects controllers/selects a sequencer";
String lastMidiMessage="Waiting";
float beatPosition, lastClock=-10, lastQuarter=-1;
float tempoReference, tempoCandidate;
int stableTempoBeats, acceptedCount;
boolean pendingTempo, haveArrangementBaseline, candidateDuringMorph;
java.util.BitSet acceptedParts=new java.util.BitSet(), candidateParts=new java.util.BitSet();
float candidateBeat, lastMidiCueBeat=-100;
boolean[] confirmed=new boolean[PART_LIMIT], sustain=new boolean[PART_LIMIT], controllerPart=new boolean[PART_LIMIT];
boolean[][] pressed=new boolean[PART_LIMIT][128];
float[][] heldVelocity=new float[PART_LIMIT][128];
float[] controls=new float[PART_LIMIT], impulse=new float[3], attack=new float[3];
int[] hits=new int[PART_LIMIT], familyForPart=new int[PART_LIMIT];
float[] firstHit=new float[PART_LIMIT], recentBeat=new float[PART_LIMIT];
String[] partLabel=new String[PART_LIMIT];

class MidiEnergy {
  float level, bass, mids, highs, kick, swell, tick;
  boolean beatNow;
}

float midiTime() { return clockTime; }
void setupInput() { connectMidi(false); }

void readInput(float dt) {
  Runnable event;
  while ((event=incomingMidi.poll())!=null) event.run();
  if (transportRunning && midiTime()-lastClock>0.5) beatPosition+=dt*bpm/60;
  float[] wanted=new float[3];
  for (int c=0;c<PART_LIMIT;c++) {
    float held=0;
    for (int n=0;n<128;n++) held=max(held,heldVelocity[c][n]*0.65);
    int family=familyForPart[c];
    wanted[family]=max(wanted[family],max(held,controls[c]));
  }
  for (int f=0;f<3;f++) {
    impulse[f]*=exp(-dt*(f==2 ? 10 : 5));
    attack[f]*=exp(-dt*(f==2 ? 14 : 9));
    float target=max(wanted[f],impulse[f]);
    voices[f]=follow(voices[f],target,target>voices[f] ? 32 : 8,dt);
  }
  audio.bass=voices[0]; audio.mids=voices[1]; audio.highs=voices[2];
  audio.kick=attack[0]; audio.swell=attack[1]; audio.tick=attack[2];
  float level=max(audio.bass,max(audio.mids,audio.highs));
  audio.level=follow(audio.level,level,level>audio.level ? 24 : 7,dt);
  if (audio.level<0.0005) audio.level=0;
  if (audio.level>0.01) playing=true;
  if (transportRunning) checkNewParts();
}

void resetInput() {
  incomingMidi.clear();
  transportRunning=true; beatPosition=0; ticks=0;
  lastClock=-10; lastQuarter=-1;
  tempoReference=tempoCandidate=0; stableTempoBeats=0; pendingTempo=false;
  parts=acceptedCount=0; acceptedParts.clear(); candidateParts.clear();
  haveArrangementBaseline=false; candidateDuringMorph=false;
  candidateBeat=0; lastMidiCueBeat=-100; receivedMessages=0;
  for (int c=0;c<PART_LIMIT;c++) {
    clearChannel(c); confirmed[c]=false; hits[c]=0;
    firstHit[c]=0; recentBeat[c]=-100;
    familyForPart[c]=(c%16)%3;
    partLabel[c]="CH "+(c%16+1);
  }
  for (MidiPort port:hardwareInputs) { port.clearValues(); port.labelParts(); }
  for (int f=0;f<3;f++) impulse[f]=attack[f]=voices[f]=0;
  audio=new MidiEnergy();
}

void inputKey() {
  if (key=='i' || key=='I') connectMidi(true);
}

boolean isPadController(String name) {
  String compact=name.toLowerCase().replace(" ","");
  return compact.contains("lpd8") || compact.contains("midimix");
}

void stopHardwareInputs() {
  for (MidiPort port:hardwareInputs) port.close();
  hardwareInputs.clear(); incomingMidi.clear();
  java.util.Arrays.fill(controllerPart,false);
}

void connectMidi(boolean next) {
  stopHardwareInputs(); resetInput();
  String[] names=MidiIn.available_inputs();
  IntList controllers=new IntList(), ordinary=new IntList();
  for (int i=0;i<names.length;i++) {
    if (names[i].toLowerCase().contains("real time sequencer")) continue;
    if (isPadController(names[i])) controllers.append(i); else ordinary.append(i);
  }
  int choice=-1;
  if (ordinary.size()>0) {
    if (next) for (int i=0;i<ordinary.size();i++) if (ordinary.get(i)>midiIndex) { choice=ordinary.get(i); break; }
    if (!next) for (int i=0;i<ordinary.size();i++) {
      int index=ordinary.get(i);
      if (names[index].toLowerCase().contains("euro")) { choice=index; break; }
    }
    if (choice<0) choice=ordinary.get(0);
  }
  midiIndex=choice;
  // Exactly one ordinary input owns transport/clock. Controllers cannot double it.
  if (choice>=0) openMidiPort(names[choice],choice);
  for (int i=0;i<controllers.size() && hardwareInputs.size()<MAX_PORTS;i++) {
    int index=controllers.get(i); openMidiPort(names[index],index);
  }
  if (hardwareInputs.isEmpty()) inputStatus="No MIDI input. Connect a controller or sequencer; I retries.";
  else {
    inputStatus="MIDI: ";
    for (int i=0;i<hardwareInputs.size();i++) inputStatus+=(i==0 ? "" : " + ")+hardwareInputs.get(i).name;
  }
  println(inputStatus);
}

void openMidiPort(String name,int index) {
  try {
    MidiIn input=new MidiIn(index);
    if (input.is_open()) hardwareInputs.add(new MidiPort(name,input,16*(hardwareInputs.size()+1)));
    else input.close();
  } catch(Exception e) { println("MIDI input "+name+": "+e.getMessage()); }
}

// Wellen parses on its MIDI thread. Only these queued callbacks touch the picture.
class MidiPort implements MidiInListener {
  final String name; final MidiIn input; final int base; final boolean controller;
  boolean open=true;
  int nextNote, nextControl;
  int[] noteLane=new int[2048], controlLane=new int[2048];
  float[] controlValue=new float[2048];
  MidiPort(String name,MidiIn input,int base) {
    this.name=name; this.input=input; this.base=base; controller=isPadController(name);
    java.util.Arrays.fill(noteLane,-1); java.util.Arrays.fill(controlLane,-1);
    labelParts(); input.add_listener(this);
  }
  void labelParts() {
    for (int i=0;i<16;i++) {
      controllerPart[base+i]=controller;
      familyForPart[base+i]=(controller ? i%8 : i)%3;
      partLabel[base+i]=name+(controller ? (i<8 ? " pad " : " control ")+(i%8+1) : " CH "+(i+1));
    }
  }
  void clearValues() { java.util.Arrays.fill(controlValue,0); }
  void close() { open=false; input.remove_listener(this); input.close(); }
  void queue(Runnable event) { incomingMidi.add(() -> { if (open) event.run(); }); }
  int learnedLane(int[] lanes,int key,boolean note) {
    if (lanes[key]<0) lanes[key]=(note ? nextNote++ : nextControl++)%8;
    return lanes[key];
  }
  public void receive_note_on(int c,int n,int v) {
    queue(() -> {
      int lane=controller ? learnedLane(noteLane,c*128+n,true) : c;
      midi_note_on(base+lane,n,v);
    });
  }
  public void receive_note_off(int c,int n,int v) {
    queue(() -> {
      int lane=controller ? noteLane[c*128+n] : c;
      if (lane>=0) midi_note_off(base+lane,n,v);
    });
  }
  public void receive_control_change(int c,int number,int value) {
    queue(() -> {
      if (!controller) { midi_control_change(base+c,number,value); return; }
      if (number>=120) {
        if (number==120 || number==121 || number==123) {
          clearValues();
          for (int i=0;i<16;i++) { clearChannel(base+i); hits[base+i]=0; recentBeat[base+i]=-100; }
        }
        receivedMessages++; lastMidiMessage=name+" CC "+number+" = "+value; return;
      }
      int key=c*128+number, lane=learnedLane(controlLane,key,false), part=base+8+lane;
      controlValue[key]=constrain(value/127.0,0,1);
      float amount=0;
      for (int i=0;i<controlValue.length;i++) if (controlLane[i]==lane) amount=max(amount,controlValue[i]);
      midi_control_change(part,1,round(amount*127));
      lastMidiMessage=name+" CC "+number+" -> control "+(lane+1);
      if (transportRunning && value>0) onBeat(max(0.25,value/127.0));
    });
  }
  public void clock_start() { if (!controller) queue(() -> midi_clock_start()); }
  public void clock_continue() { if (!controller) queue(() -> midi_clock_continue()); }
  public void clock_stop() { if (!controller) queue(() -> midi_clock_stop()); }
  public void clock_tick() { if (!controller) queue(() -> midi_clock_tick()); }
}

// Direct callbacks retain ordinary MIDI channels 1–16.
void midi_note_on(int channel,int note,int velocity) {
  if (!transportRunning || channel<0 || channel>=PART_LIMIT || note<0 || note>127) return;
  if (velocity==0) { midi_note_off(channel,note,0); return; }
  receivedMessages++; lastMidiMessage=partLabel[channel]+" note "+note+" / velocity "+velocity;
  float strength=constrain(velocity/127.0,0,1); int family=familyForPart[channel];
  impulse[family]=max(impulse[family],strength); attack[family]=max(attack[family],strength);
  audio.beatNow=true; playing=true; onBeat(strength);
  pressed[channel][note]=true; heldVelocity[channel][note]=strength;
  if (hits[channel]==0) firstHit[channel]=beatPosition;
  hits[channel]++; recentBeat[channel]=beatPosition;
}

void midi_note_off(int channel,int note,int velocity) {
  if (channel<0 || channel>=PART_LIMIT || note<0 || note>127) return;
  receivedMessages++; lastMidiMessage=partLabel[channel]+" note off "+note;
  pressed[channel][note]=false;
  if (!sustain[channel]) heldVelocity[channel][note]=0;
}

void midi_control_change(int channel,int number,int value) {
  if (channel<0 || channel>=PART_LIMIT) return;
  receivedMessages++; lastMidiMessage=partLabel[channel]+" CC "+number+" = "+value;
  if (number==120 || number==123) { clearChannel(channel); recentBeat[channel]=-100; hits[channel]=0; }
  if (number==121) { controls[channel]=0; sustain[channel]=false; releaseSustain(channel); }
  if (!transportRunning) return;
  if (number==1) {
    controls[channel]=constrain(value/127.0,0,1);
    if (value>0) {
      playing=true;
      if (hits[channel]==0) firstHit[channel]=beatPosition;
      hits[channel]++; recentBeat[channel]=beatPosition;
    }
  }
  if (number==64) { sustain[channel]=value>=64; if (!sustain[channel]) releaseSustain(channel); }
}

void releaseSustain(int channel) {
  for (int n=0;n<128;n++) if (!pressed[channel][n]) heldVelocity[channel][n]=0;
}

void clearChannel(int channel) {
  controls[channel]=0; sustain[channel]=false;
  for (int n=0;n<128;n++) { pressed[channel][n]=false; heldVelocity[channel][n]=0; }
}

void checkNewParts() {
  java.util.BitSet mask=new java.util.BitSet(); parts=0;
  for (int c=0;c<PART_LIMIT;c++) {
    boolean held=controls[c]>0;
    for (int n=0;n<128;n++) if (heldVelocity[c][n]>0) held=true;
    boolean active=held || beatPosition-recentBeat[c]<4;
    if (!active) { confirmed[c]=false; hits[c]=0; }
    else if (!confirmed[c] && (held || hits[c]>=(controllerPart[c] ? 1 : 2)) && beatPosition-firstHit[c]>=0.5) confirmed[c]=true;
    if (confirmed[c]) { mask.set(c); parts++; }
  }
  boolean morphing=abs(stage-musicStage)>0.08 || ringMode==1 || ringMode==3;
  if (!mask.equals(candidateParts)) {
    candidateParts=(java.util.BitSet)mask.clone(); candidateBeat=beatPosition;
    candidateDuringMorph=morphing;
  }
  if (beatPosition-candidateBeat<1 || parts==0) return;
  // Learn the starting mix, even if the song starts with several instruments.
  if (!haveArrangementBaseline) {
    acceptedParts=mask; acceptedCount=parts; haveArrangementBaseline=true;
    pendingTempo=false; return;
  }
  boolean changed=!mask.equals(acceptedParts);
  boolean tempoChanged=pendingTempo;
  if (!changed && !tempoChanged) return;
  java.util.BitSet added=(java.util.BitSet)mask.clone(); added.andNot(acceptedParts);
  String reason=changed ? (parts>acceptedCount ? "MIDI part added" : "MIDI arrangement changed") : "MIDI tempo changed";
  // Consume each confirmed change once, including changes inside a transition.
  // It must never become a queued cue that fires when the animation settles.
  acceptedParts=mask; acceptedCount=parts; pendingTempo=false;
  if (morphing || (changed && candidateDuringMorph)) return;
  // Group related layer releases/tempo changes instead of replaying their cues.
  if (musicStage==3 && beatPosition-lastMidiCueBeat<8) return;
  if (musicStage<3) {
    // Thinning learns the new mix; only a new part develops the introduction.
    if (changed && !added.isEmpty() && musicalChange(reason)) musicPaletteChange();
  } else if (musicalChange(reason)) {
    lastMidiCueBeat=beatPosition; musicPaletteChange();
  }
}

void midi_clock_start() {
  receivedMessages++; transportRunning=true;
  ticks=0; lastQuarter=-1; lastClock=-10;
  tempoReference=tempoCandidate=0; stableTempoBeats=0; pendingTempo=false;
  lastMidiMessage="START";
}
void midi_clock_continue() { receivedMessages++; transportRunning=true; lastMidiMessage="CONTINUE"; }
void midi_clock_stop() {
  receivedMessages++; transportRunning=false; lastMidiMessage="STOP";
  for (int c=0;c<PART_LIMIT;c++) { clearChannel(c); hits[c]=0; confirmed[c]=false; recentBeat[c]=-100; }
  for (MidiPort port:hardwareInputs) port.clearValues();
  for (int f=0;f<3;f++) impulse[f]=attack[f]=0;
  parts=acceptedCount=0; acceptedParts.clear(); candidateParts.clear(); pendingTempo=false;
  haveArrangementBaseline=false; candidateDuringMorph=false;
}
void midi_clock_tick() {
  if (!transportRunning) return;
  receivedMessages++;
  float now=midiTime();
  if (now-lastClock>1) { ticks=0; lastQuarter=-1; }
  lastClock=now; ticks++; beatPosition+=1.0/24;
  if (ticks%24==0) {
    if (parts==0) { impulse[0]=max(impulse[0],0.6); attack[0]=max(attack[0],0.6); audio.beatNow=true; }
    onBeat(0.55);
    if (lastQuarter>=0) observeTempo(60/max(0.001,now-lastQuarter));
    lastQuarter=now;
  }
}

void observeTempo(float measured) {
  if (measured<40 || measured>240) return;
  bpm=follow(bpm,measured,4,0.25);
  if (tempoCandidate==0 || abs(measured-tempoCandidate)>measured*0.07) {
    tempoCandidate=measured; stableTempoBeats=1;
  } else { tempoCandidate=lerp(tempoCandidate,measured,0.35); stableTempoBeats++; }
  if (stableTempoBeats<4) return;
  if (tempoReference==0) tempoReference=tempoCandidate;
  else if (abs(tempoCandidate-tempoReference)>max(12,tempoReference*0.12)) {
    pendingTempo=true; tempoReference=tempoCandidate; stableTempoBeats=0;
  }
}

// Release every hardware input when the sketch closes.
public void dispose() {
  stopHardwareInputs();
  super.dispose();
}
