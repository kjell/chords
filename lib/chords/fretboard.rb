require 'chords/chord_factory'
require 'chords/fingering'
require 'chords/text_formatter'

module Chords
  
  class Fretboard
    DEFAULT_FRETS = 14
    
    # See http://en.wikipedia.org/wiki/Guitar_tunings
    TUNINGS = {
               # Some usual ones
               :standard => [E.new, A.new, D.new, G.new(1), B.new(1), E.new(2)],
               :drop_d   => [D.new(-1), A.new, D.new, G.new(1), B.new(1), E.new(2)],
               :ddd      => [D.new(-1), A.new, D.new, G.new(1), B.new(1), D.new(1)], # double-dropped D
               :dadgad   => [D.new(-1), A.new, D.new, G.new(1), A.new(1), D.new(1)],
               
               # Major open tunings
               :open_e   => [E.new, B.new, E.new(1), Gs.new(1), B.new(1), E.new(2)],
               :open_d   => [D.new(-1), A.new, D.new, Fs.new(1), A.new(1), D.new(1)],
               :open_a   => [E.new, A.new, E.new(1), A.new(1), Cs.new(1), E.new(2)],
               :open_g   => [D.new(-1), G.new, D.new, G.new(1), B.new(1), D.new(1)],
               :open_c   => [C.new(-1), G.new, C.new, G.new(1), C.new(1), E.new(2)],
               
               # Cross-note tunings
               :cross_e  => [E.new, B.new, E.new(1), G.new(1), B.new(1), E.new(2)],
               :cross_d  => [D.new(-1), A.new, D.new, F.new(1), A.new(1), D.new(1)],
               :cross_a  => [E.new, A.new, E.new(1), A.new(1), C.new(1), E.new(2)],
               :cross_g  => [D.new(-1), G.new, D.new, G.new(1), Bb.new(1), D.new(1)],
               :cross_c  => [C.new(-1), G.new, C.new, G.new(1), C.new(1), Eb.new(1)],
               
               # Modal tunings
               :cacgce   => [C.new(-1), A.new, C.new, G.new(1), C.new(1), E.new(2)],
               :e_modal  => [E.new, B.new, E.new(1), E.new(1), B.new(1), E.new(2)],
               :g_modal  => [G.new, G.new, D.new, G.new(1), B.new(1), D.new(1)],
               :gsus2    => [D.new(-1), G.new, D.new, G.new(1), A.new(1), D.new(1)],
               :c15      => [C.new(-1), G.new, D.new, G.new(1), C.new(1), D.new(1)],
               
               # "Extended chord" tunings
               :dmaj7    => [D.new(-1), A.new, D.new, Fs.new(1), A.new(1), Cs.new(1)]
              }
    
    attr_reader :frets, :open_notes
    attr_accessor :stretch
    
    def initialize(open_notes, frets)
      @open_notes, @frets = open_notes, frets
      @formatter = TextFormatter.new(self)
    end
    
    def self.method_missing(meth, *args)
      if TUNINGS.has_key?(meth)
        Fretboard.new(TUNINGS[meth], (args.first || DEFAULT_FRETS))
      else
        super
      end
    end
    
    def find(chord, opts={})
      Fingering.find_variations(self, chord, opts)
    end
    
    def print(chord, opts={})
      fingerings = find(chord, opts)
      @formatter.print(fingerings)
    end
    
    def fretted_notes(presses)
      open_notes.zip(presses).map {|open, pressed| (open + pressed)}
    end
    
  end
end