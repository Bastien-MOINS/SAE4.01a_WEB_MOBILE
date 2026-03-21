function searchBarFunction(length) {
  var input, filter, table, tbody, tr, td, i, txtValue;
  input = document.getElementById("searchBar");
  filter = input.value.toUpperCase().trim();
  table = document.getElementById("table");
  tbody = table.getElementsByTagName("tbody")[0];
  tr = tbody.getElementsByTagName("tr");

  const filterWords = filter.split(' ').filter(word => word.length > 0);

  for (i = 0; i < tr.length; i++) {
    if (tr[i].parentNode.tagName.toUpperCase() === 'TBODY') {
      let rowText = "";
      
      // Fixer la boucle interne pour qu'elle parcoure correctement les colonnes en utilisant 'j'
      for (let j = 0; j < length; j++) {
        td = tr[i].getElementsByTagName("td")[j];
        if (td) {
          rowText += (td.textContent || td.innerText).toUpperCase() + " ";
        }
      }

      // Vérifier si tous les mots-clés apparaissent quelque part dans le texte de la ligne assemblée
      const isMatch = filterWords.every(word => rowText.includes(word));

      if (isMatch) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }
  }
}