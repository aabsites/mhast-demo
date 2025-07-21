# Extract content based on AEM roles and structure
{
  sections: [
    # Hero section - find block with name "hero"
    {
      type: "hero",
      content: (
        .. | select(."aem-role"? == "block" and .name? == "hero") |
        {
          title: (.. | select(."aem-role"? == "heading" and .level? == 1) | 
                 if .children then .children[] | recurse | select(.type? == "text") | .value else empty end),
          image: (.. | select(."aem-role"? == "image") | 
                 .. | select(.tagName? == "img") | .properties.src)
        }
      )
    },
    
    # Main content section - paragraphs and headings outside blocks
    {
      type: "content",
      content: {
        title: (.. | select(."aem-role"? == "heading" and .level? == 1 and (.properties.id? == "exploring-the-open-road")) |
               .children[] | recurse | select(.type? == "text") | .value),
        description: (.. | select(."aem-role"? == "paragraph" and (.children[0].type? == "text")) |
                     .children[0].value),
        reasons: {
          title: (.. | select(."aem-role"? == "heading" and .level? == 2 and (.properties.id? == "reasons-to-love-biking")) |
                 .children[] | recurse | select(.type? == "text") | .value),
          items: [.. | select(."aem-role"? == "list" and .ordered? == true) |
                 .children[] | select(."aem-role"? == "list-item") |
                 {
                   title: (.children[] | select(."aem-role"? == "emphasis") | 
                          .children[] | select(.type? == "text") | .value),
                   description: (.children[] | select(.type? == "text") | .value | ltrimstr(" – "))
                 }]
        }
      }
    },
    
    # Cards section - find block with name "cards"
    {
      type: "cards", 
      content: {
        title: (.. | select(."aem-role"? == "heading" and .level? == 2 and (.properties.id? == "explore-more-articles")) |
               .children[] | recurse | select(.type? == "text") | .value),
        cards: [.. | select(."aem-role"? == "block" and .name? == "cards") |
               .children[] | select(."aem-role"? == "row") |
               {
                 title: (.children[] | select(."aem-role"? == "cell") | 
                        .. | select(."aem-role"? == "emphasis") |
                        .children[] | select(.type? == "text") | .value),
                 description: (.children[] | select(."aem-role"? == "cell") |
                              .. | select(."aem-role"? == "paragraph" and 
                                         (.children[0].type? == "text") and 
                                         (.children[0]."aem-role"? != "emphasis")) |
                              .children[0].value),
                 image: (.children[] | select(."aem-role"? == "cell") |
                        .. | select(."aem-role"? == "image") |
                        .. | select(.tagName? == "img") | .properties.src)
               }]
      }
    }
  ]
}