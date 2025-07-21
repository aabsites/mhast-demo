{
  hero: (
    .. | objects | select(.["aem-role"] == "block" and .name == "hero") |
    {
      title: (
        .. | objects | select(.tagName == "h1" and has("children")) |
        .children[] | select(.type == "text") | .value
      ),
      image: (
        .. | objects | select(.tagName == "img" and has("properties")) |
        .properties.src
      )
    }
  ),
  cards: [
    .. | objects | select(.["aem-role"] == "block" and .name == "cards") |
    .children[] | select(.["aem-role"] == "row") |
    {
      title: (
        .. | objects | select(.tagName == "strong" and has("children")) |
        .children[] | select(.type == "text") | .value
      ),
      image: (
        .. | objects | select(.tagName == "img" and has("properties")) |
        .properties.src
      ),
      description: (
        .children[] | select(.["aem-role"] == "cell") |
        .children[] | select(.tagName == "p" and (.children[] | select(.type == "text"))) |
        .children[] | select(.type == "text") | .value
      )
    }
  ]
}