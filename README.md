# Enigma
German Enigma implemented in Ruby

Usage: `bin/run.rb [options] encode|decode message`  
Options: `rotors`, `reflector`, `ring_settings`, `plug_pairs`, `day_key`.

The first two words of the message are always the unique key and message key. The enigma cypher
only encodes letters of the alphabet and remove all spaces and punctuation.

## Example Usage

Rotors: `I II III`  
Reflector: `B`  
Ring positions: `13 04 21`  
Plug pairs: `AH CP RB IP KX WO`  
Unique Key: `OMG`  
Message Key: `WTF`  
Message: `Jahwohl`  

Encode: `bin/run.rb rotors="I II III" reflector="B" ring_settings="13 04 21" plug_pairs="AH CP RB IL KX WO" encode "OMG WTF Jahwohl"`  
Result: `OMG BKK PPSQA UE`

Decode: `bin/run.rb rotors="I II III" reflector="B" ring_settings="13 04 21" plug_pairs="AH CP RB IL KX WO" decode "OMG BKK PPSQA UE"`  
Result: `OMG WTF JAHWO HL` or `OMG WTF Jahwohl`
