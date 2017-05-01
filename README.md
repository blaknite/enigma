# Enigma
German Enigma implemented in Ruby

Usage: `bin/run.rb [options] encode|decode message`  
Options: `rotors`, `ring_positions`, `plug_pairs`, `day_key`.

The first word of the message is always the message key. The enigma cypher only encodes letters
of the alphabet and remove all spaces and punctuation.

## Example Usage

Rotors: `I II III`  
Ring positions: `13 04 21`  
Plug pairs: `AH CP RB IP KX WO`  
Day key: `LOL`  
Unique Key: `OMG`  
Message Key: `WTF`  
Message: `Jahwohl`  

Encode: `bin/run.rb rotors="I II III" ring_positions="13 04 21" plug_pairs="AH CP RB IL KX WO" day_key="LOL" encode "OMG WTF Jahwohl"`  
Result: `OMG VMY IJBIH PE`

Decode: `bin/run.rb rotors="I II III" ring_positions="13 04 21" plug_pairs="AH CP RB IL KX WO" day_key="LOL" decode "OMG VMY IJBIH PE"`  
Result: `OMG WTF JAHWO TL` or `OMG Jahwohl`
