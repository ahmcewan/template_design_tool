library(shiny)
library(DT)
library(stringi)
source("html.R")
source("resume.R")


ui <- fluidPage(


    titlePanel("Donor Design Tool for CRISPR-Cas9 Targeted Insertion of Short DNA Fragments"),
    
    sidebarPanel(
        shinyFeedback::useShinyFeedback(),
        textAreaInput(
            "seq",
            "Sequence",
            placeholder = "Input a raw DNA Sequence at least 150bp long",
            height = '200px',
            value = ""
        ),
        textInput("insert", "Insert", placeholder = "Input an insert sequence such as LoxP" , value = ""),
        actionButton("example", "Try an Example"),
        verbatimTextOutput("validate"),
        
    ),
    
    mainPanel(
        tabsetPanel(
        id = "inTabset",
        type = "tabs",
        tabPanel("Info", info, uiOutput("img")),
        tabPanel("Results", DTOutput('table', width = "80%")),
        tabPanel("Andrea McEwan | Resume", resume )
    )
  ,)
)


# functions
invalid.seq.message <- "Please enter a valid DNA sequence"


validate.sequence <- function(char.input) {
    if (stri_detect_charclass(toupper(char.input), "[^ATCG]", negate = TRUE)) {
        return(TRUE)
    } else {
        return(FALSE)
    }
}

clean.input <- function(seq) {
    clean.seq <- stri_replace_all_charclass(seq, "\\p{WHITE_SPACE}", "")
}


find.pams <- function(seq) {
    if (nchar(seq) < 150) {
        return(FALSE)
    } else{
        pam.res <- tryCatch({
            res <- NULL
            full.seq <- seq
            sub.seq <- substr(full.seq, 60, nchar(full.seq) - 60)
            forward.pam <-
                unlist(gregexpr("(?=[A-z]GG)", toupper(sub.seq), perl = TRUE))
            if(!forward.pam[1] == -1L){
              for (i in 1:length(forward.pam)) {
                  stop <- forward.pam[i] + 61
                  sgRNA.f <- substr(full.seq, stop - 22, stop)
                  res <-
                      rbind(res,
                            data.frame(
                                dir = "F",
                                index = stop,
                                guide = sgRNA.f
                            ))
              }
            }  
            reverse.pam <-
                unlist(gregexpr("(?=CC[A-z])", toupper(sub.seq), perl = TRUE))
            if(!reverse.pam[1]== -1L)
              for (j in 1:length(reverse.pam)) {
                  start <- reverse.pam[j] + 59
                  sgRNA.r <- substr(full.seq, start, start + 22)
                  res <-
                      rbind(res,
                            data.frame(
                                dir = "R",
                                index = start,
                                guide = sgRNA.r
                            ))
              }
            return(res)
        },
        error = function(cond) {
            return(FALSE)
        })
        return(pam.res)
    }
}


get.homology.template <- function(pam.res, full.seq, ins) {
    homology.arms <- tryCatch({
        hdr.template <- NULL
        for (i in 1:nrow(pam.res)) {
            guide <- pam.res$guide[i]
            index <- pam.res$index[i]
            if (pam.res$dir[i] == "F") {
                left.arm <- substring(full.seq,index-66, index - 7)
                right.arm <- substring(full.seq, index - 6, index + 53)
            } else if (pam.res$dir[i] == "R") {
                left.arm <- substring(full.seq,  index-53 , index + 6)
                right.arm <- substring(full.seq, index + 7, index + 66)
            }
            hdr.template <- rbind(hdr.template,data.frame(guide,paste0(left.arm, ins , right.arm)))
            
        }
        colnames(hdr.template) <- c("sgRNA Guide", "Oligo donor")
        return(hdr.template)
    },
    error = function(cond) {
        return(FALSE)
    })
}


# Server logic to find PAM sequences and design ssODN
server <- function(input, output, session) {
  
    #populate sequences on button click   
    observeEvent(input$example, {
        updateTextAreaInput(session, "seq",value = Mecp2.intron2)
        updateTextInput(session, "insert", value = NheI.loxP)
        updateTabsetPanel(session, "inTabset", selected = "Results")
        
    })
  
    observe({
      req(input$seq, input$insert)
      updateTabsetPanel(session, "inTabset", selected = "Results")
    })
      
    
    input.seq <- reactive({
        input <- clean.input(input$seq)
        shinyFeedback::feedbackWarning("seq", !validate.sequence(input), invalid.seq.message)
        req(validate.sequence)
        return(input)
    })
    

    insert.seq <- reactive({
        insert <- clean.input(input$insert)
        shinyFeedback::feedbackWarning("insert", !validate.sequence(insert), invalid.seq.message)
        req(validate.sequence)
        return(insert)

    })
    
    
  # Output error messages 
    output.res <- reactive({
        res <- c(input.seq(), insert.seq())
        return(NULL)
    })
    
    output$validate <- renderText(output.res())
    
    output$img <- renderUI({
      tags$img(src = "https://els-jbs-prod-cdn.jbs.elsevierhealth.com/cms/attachment/017ca800-b96c-4cc9-b05e-6377caab7610/figs3.jpg", 
               height="45%", width="45%")
    })
    
 # validate inputs and output results   
    output$table <- renderDT({
        req(input$seq, input$insert)
        full.seq <- clean.input(input$seq)
        insert.seq <- clean.input(input$insert)
        pam.res <- find.pams(full.seq)
        hdr.template <- get.homology.template(pam.res, full.seq, insert.seq)
        validate(
            need(clean.input(input$seq), "* Could not interpret sequence"),
            need(clean.input(input$insert),"* Could not interpret insert sequence"),
            need(find.pams(full.seq),
                "* Could not find PAMS. Sequence must be at least 150bp long"),
            need(hdr.template,
                "* Could not find homology arms. Check that both sequences are valid"
            )
        )
        datatable(
            hdr.template,
            options = list(
                deferRender = TRUE,
                scrollX = TRUE,
                scrolly = TRUE,
                scroller = TRUE,
                autoWidth = TRUE,
                pageLength = 15,
                dom = 'tp',
                columnDefs = list(list(
                    width = '50%', targets = c(1)
                ))
                
            )
        )
    })
}


# Run the application 
shinyApp(ui = ui, server = server)

