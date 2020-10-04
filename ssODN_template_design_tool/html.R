


Mecp2.intron2 <- "GTAAGTAACCTTCCTTTTTTTTTTTTTAGTATATGTCCTGGTTTGGCCATCTGTTTTTAA
AAAAAAAAAAAAGGAAAAAAAGATATACTATTCTTGGACAGTATGAAAGTACCCCAAAGA
CAAAAAATATAACTGGGCCAAACTGTGCCATATAATAAAAAAAAGTCACTTCCCTGAGCC
CTGAAAGTTCAGTTCAGTTTGGGTAGAGTTACTTGGTAGCCACAGTGTGATCTGGGGGGT
GGGTGTCAGATTAGAGCTGGAACTGGTGATCTGCAGCTTCAGTTCACCTTGAAGCAGGAG
AGTGCTTGGCCTGAGCTCTTCACCTGTGCTGCTGCTCTTACCTAGTGGTCTTCAGCATGA
TGCTTTCTTTGATTTGGTTTGGGCTAAATGACTTGCAGGTCGATGTTAGCAAGCAGTGGT
GTGCTGCATTTTCAGATATAGGAACTGGTATGTGGTCCCCTTAGAAGAGCACCTTTCTGA
AAGTGTCACGGCACAATGGAGCCTGTGGTTAGTGGTGCTTGCTTGCTGACCTCTGATGGA
TGCATCCAGACAGATGTGCGACTCTCGGGATTCTAGAGCAGGAAAAGCTGGAAAGCCCAG
TTGTTTTTCAGACCTGACAAATCTGTACTGTGAACTACTGCGGTACCATTGTGTGGACTT
TAGTTTTTGCAAGAATGACTTGTTCTGTAATTTCTTATCCTTTATCAGGCTCAAACCTCT
CAAGCTTTTTTTAAATTAGTAATTATTCTACATTTGATAGTTTGTCACCTGTATTTCTGT
GTGATAAAACAGATAATGCCAATTGACTTTTCCTATCTTCTACAAAAGAAAATGTTGACT
GTTCACACATGCTGTGTTTTGATTGTAGCAGAGATCCCCAGTTAGCATTTTCTGTATCTC
TAAATGTATTACACACTGTACAGACGCAACACACATGTACACACACACATAGCTGATTTA
TGGGGGGGGGGGGTAAGTTTTGGGTGGAGGAGAATAGAAGAAAATGAAGATTTGATTCTG
CTTCTGATACTGTGACGTCAGTTGTCATTCTCCTCACTGTCATGAGGTATGATCCAGACC
TGACCGATCTTTGTGCTTCACACATTTATGCTGGTGGGAGTTATATGGCTAGTGCTTTGT
CTCAAGAATTCTACTAAATGTAATAGAAGCACTGATGGGTAGATGTTAGGCTGGGCGTGG
TTTGCGGTTTTTAAAGTCTTTTTCTCAGTTTATGAATGACTCTGGGAAAAAGACAGTAAT
GATACTATACATGTTTCTCCAGAGAAAGGGTGGATTTTTTTTTTTTAGAAAAAGTCTTTT
"

NheI.loxP <- "GCTAGCataacttcgtataatgtatgctatacgaagttat"


info <-   tags$div(class="col-sm-8",
                   HTML(
                     '<br>
     <p>CRSIPR-Cas9 genome editing tools has made it possible to insert or knock-in
     DNA sequences of varying sizes. The Donor Design Tool generates sgRNA and donor oligo pairs that  
     can be used for the targeted insertion of small DNA sequences with a given guide.  
     
     The design is based on the method used in <b>One-Step Generation of Mice Carrying Reporter 
     and Conditional Alleles by CRISPR/Cas-Mediated
     Genome Engineering</b> (Yang, <i>et. al</i>, 2013).
     </p>
     <br>
     <p>
     To use the application, copy and paste a 150bp (or longer) DNA sequence that will be targeted for insertion into the "Sequence" field.
     Input an insert sequence for knock-in. Once both fields are filled, the application searches the sense and antisense strand for PAM sites that are
      recognized by SpyoCas9 Cas9 (NGG) and generates a list of 20bp sgRNAs (excluding PAMs). The application then creates 60bp homology arms
      that start or end at the putative Cas9 cleavage site (4bp upstream of the PAM sequence). The tool outputs
      an oligo donor sequence by fusing the left homology arm, insert, and right
      homology arm together. Click on <b>"Try an Example"</b> to automatically fill the sequence fields and see results.
      In the example results, donor oligos are designed to insert the NheI-LoxP sequence within the second intron
      of Mecp2.
      </p>
      <br>
    '
                   )
)