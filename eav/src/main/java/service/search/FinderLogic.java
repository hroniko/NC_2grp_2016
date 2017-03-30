package service.search;

import service.tags.TagTreeManager;

import java.util.ArrayList;

/**
 * Created by Hroniko on 30.03.2017.
 */
// Класс для обработки логики запросов (OR | AND, USER | MEETING) и пр., потом будет расширяться
public class FinderLogic {


    public static ArrayList<FinderTagResponse> getWithLogic(FinderTagRequest finder) {
        // Пропускаем через парсер строку с тегами:
        ArrayList<String> part_tags = SearchParser.parse(finder.getText());
        // Подготавливаем список тегов для ответа:
        ArrayList<FinderTagResponse> finderTagResponseList = new ArrayList<>();
        System.out.println("Пришел запрос на тег [" + finder.getText() + "]");

        // По каждому тегу делаем запросы в дерево тегов:
        TagTreeManager ttm = new TagTreeManager();
        for (int i = 0; i < part_tags.size(); i++) {
            ArrayList<String> anyTagFromTree = new ArrayList<>();

            if (finder.getType().equals("user")) {
                // работаем с юзерами, загружаем подходящие теги с подвещенными юзерами
                anyTagFromTree = ttm.getTagWordListForUser(part_tags.get(i));
            } else if (finder.getType().equals("meeting")) {
                // работаем со встречами, загружаем подходящие теги с подвещенными встречами
                anyTagFromTree = ttm.getTagWordListForMeeting(part_tags.get(i));
            } else break;


            if (i == 0) { // Если это первый тег из запроса, то просто переносим в лист все найденные теги из ответа
                for (int j = 0; j < anyTagFromTree.size(); j++) {
                    FinderTagResponse finderTagResponse = new FinderTagResponse();
                    finderTagResponse.setId(j);
                    finderTagResponse.setText(anyTagFromTree.get(j));
                    finderTagResponseList.add(finderTagResponse);
                }
            } else { // Иначе начинается самый трэш
                // Если у нас стоит логика обединения результатов нескольких тегов-запросов как OR, то все хорошо, просто проверяем на наличие уже такого тега и добавляем если его нет
                if (finder.getOperation().equals("or")) {



                    for (int j = 0; j < anyTagFromTree.size(); j++) {
                        boolean flagOK = false;
                        for (int k = 0; k < finderTagResponseList.size(); k++){
                            if (finderTagResponseList.get(k).getText().equals(anyTagFromTree.get(j))) { // Если совпадают теги, то не добавляем
                                flagOK = true;
                                break;
                            }
                        }
                        // Проверяем флажок:
                        if (!flagOK) { // Если флаг сброшен, то совпадений не нашли, потому надо добавить текущий тег
                            FinderTagResponse finderTagResponse = new FinderTagResponse();
                            finderTagResponse.setId(j);
                            finderTagResponse.setText(anyTagFromTree.get(j));
                            finderTagResponseList.add(finderTagResponse);
                        }
                    }





                }
                // Иначе если у нас стоит логика обединения результатов нескольких тегов-запросов как AND, то все фигово, проверяем на совпадение привешенных юзеров (или встреч) и несовпадающие узлы из первого результата удаляем
                else if (finder.getOperation().equals("and")) {
                    for (int k = 0; k < finderTagResponseList.size(); k++) { // Пробегаем по всем существующим в ответе тегам
                        // получаем для текущего тега список подписанных юзеров (или встреч)
                        ArrayList<Integer> ids = new ArrayList<>();
                        if (finder.getType().equals("user")) {
                            // работаем с юзерами, загружаем подходящие айди с подвещенными юзерами
                            ids = ttm.getUserListWithTag(part_tags.get(k));
                        } else if (finder.getType().equals("meeting")) {
                            // работаем со встречами, загружаем подходящие айди с подвещенными встречами
                            ids = ttm.getMeetingListWithTag(part_tags.get(k));
                        }

                        // А затем пробегаем по всем вновь прибывшим тегам и смотрим совпадение юзеров:
                        for (int j = 0; j < anyTagFromTree.size(); j++) { // Пробегаем по всем вновь прибывшим тегам
                            ArrayList<Integer> ids2 = new ArrayList<>();
                            if (finder.getType().equals("user")) {
                                // работаем с юзерами, загружаем подходящие айди с подвещенными юзерами
                                ids2 = ttm.getUserListWithTag(anyTagFromTree.get(j));
                            } else if (finder.getType().equals("meeting")) {
                                // работаем со встречами, загружаем подходящие айди с подвещенными встречами
                                ids2 = ttm.getMeetingListWithTag(anyTagFromTree.get(j));
                            }

                            boolean flagOK = false; // Флаг, показывающий, что данный тег надо оставить
                            // Пробегаем по всем айдишникам тега из списка на отправку
                            for (int m = 0; m < ids.size(); m++) {
                                if (ids2.contains(ids.get(m))) { // сли попали на совпадение тегов, то выставляем флаг и выходим з этого внуреннего цикла
                                    flagOK = true;
                                    break;
                                }
                            }

                            // Проверяем флажок:
                            if (!flagOK) { // Если флаг сброшен, то совпадений не нашли, потому надо удалить текущий тег из списка на отправку
                                finderTagResponseList.remove(k);
                            }

                        }

                    }

                }

            }

        }

        return finderTagResponseList;
    }
}
