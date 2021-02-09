# Enigma

[![Build status](https://badge.buildkite.com/f958e01d85fd3af5c2613a32362e07c9aef9aa689d37bfaea2.svg)](https://buildkite.com/blaknite/enigma)

German Enigma implemented in Ruby

Usage: `bin/run.rb`

The first two words of the message are always the unique key and message key. The enigma cypher
only encodes letters of the alphabet and remove all spaces and punctuation.

You can find out more about how the Enigma works here: http://users.telenet.be/d.rijmenants/en/enigmatech.htm

## Example Usage

Rotors: `I II III`
Ring settings: `13 04 21`
Reflector: `B`
Plug pairs: `AH CP RB IL KX WO`
Unique Key: `OMG`
Message Key: `WTF`
Message: `Jahwohl`

```
$ bin/run.rb
Select the rotors [I II III]:
Provide the ring settings [01 01 01]: 13 04 21
Select the reflector [B]:
Provide the plug pairs: AH CP RB IL KX WO
Encode or decode? [encode]:
Enter the unique key: OMG
Enter the message key: WTF
Enter the message: Jahwohl

OMG BKK PPSQA UE
```

```
$ bin/run.rb
Select the rotors [I II III]:
Provide the ring settings [01 01 01]: 13 04 21
Select the reflector [B]:
Provide the plug pairs: AH CP RB IL KX WO
Encode or decode? [encode]: decode
Enter the unique key: OMG
Enter the message key: BKK
Enter the message: PPSQA UE

OMG WTF JAHWO HL
```
