export const state = () => ({
  data: {
    name: null,
    email: null,
    password: "",
    passwordConfirmation: "",
    tel: null,
    postcode: null,
    address: null,
  },
  headers: {},
});

export const getters = {
  getUserData: (state) => {
    return state.data;
  },
};

export const actions = {
  async getUserData({ commit }, { url, headers }) {
    const userData = await this.$axios.get(url);
    commit({
      type: "setUserData",
      data: {
        userData,
        headers,
      },
    });
  },
};

export const mutations = {
  setUserData(state, { data }) {
    state.data = data.userData.data;
    state.headers = data.headers;
  },
  changeUserName(state, value) {
    state.data.name = value;
  },
  changeUserEmail(state, value) {
    state.data.email = value;
  },
  changeUserPassword(state, value) {
    state.data.password = value;
  },
  changeUserPasswordConfirmation(state, value) {
    state.data.passwordConfirmation = value;
  },
  changeUserTel(state, value) {
    state.data.tel = value;
  },
  changeUserPostcode(state, value) {
    state.data.postcode = value;
  },
  changeUserAddress(state, value) {
    state.data.address = value;
  },
};
