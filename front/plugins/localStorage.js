import createPersistedState from "vuex-persistedstate";

export default ({ store }) => {
  createPersistedState({
    key: "officeSearch",
    paths: ["offices", "totalPage", "currentPage", "totalCount"],
  })(store);
};
